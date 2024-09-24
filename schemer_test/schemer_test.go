package schemertest

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"testing"
	"time"

	adapter_sdk "github.com/BrobridgeOrg/gravity-sdk/v2/adapter"
	"github.com/BrobridgeOrg/gravity-sdk/v2/core"
	product_sdk "github.com/BrobridgeOrg/gravity-sdk/v2/product"
	subscriber_sdk "github.com/BrobridgeOrg/gravity-sdk/v2/subscriber"
	gravity_sdk_types_product_event "github.com/BrobridgeOrg/gravity-sdk/v2/types/product_event"
	"github.com/cucumber/godog"
	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/client"
	"github.com/google/uuid"
	"github.com/nats-io/nats.go"
	"github.com/spf13/pflag"
	"google.golang.org/protobuf/proto"
)

var schemas = make(map[string]string)
var jetstreamURL = "127.0.0.1:32803"
var receivePayload = make(map[string]interface{})

var opts = godog.Options{
	Format:        "pretty",
	Paths:         []string{"./"},
	StopOnFailure: false,
}

func init() {
	godog.BindCommandLineFlags("godog.", &opts)
}

func TestMain(_ *testing.M) {
	pflag.Parse()
	suite := godog.TestSuite{
		ScenarioInitializer: InitializeScenario,
		Options:             &opts,
	}
	if suite.Run() != 0 {
		log.Fatal("non-zero status returned, failed to run feature tests")
	}
}

func PublishEvent(eventName, payload string) error {
	// Create adapter connector
	client := CreateClient()
	acOpts := adapter_sdk.NewOptions()
	acOpts.Domain = "default"
	adapterClient := adapter_sdk.NewAdapterConnectorWithClient(client, acOpts)

	payload = processPayload(payload)
	if err := Publish(adapterClient, eventName, payload); err != nil {
		return fmt.Errorf("Publish() failed: %v", err)
	}
	return nil
}

func SubscribeDataProduct(dataProduct string) error {
	client := core.NewClient()
	options := core.NewOptions()
	client.Connect("0.0.0.0:32803", options)
	if err := Subscribe(client, dataProduct); err != nil {
		return err
	}
	return nil
}

func CreateClient() *core.Client {
	client := core.NewClient()
	options := core.NewOptions()
	if err := client.Connect("0.0.0.0:32803", options); err != nil {
		panic(err)
	}
	return client
}

func CreateProduct(pc *product_sdk.ProductClient, dataProduct string, schemaJSON string) error {
	var schema map[string]interface{}
	err := json.Unmarshal([]byte(schemaJSON), &schema)
	if err != nil {
		return errors.New("invalid schema format")
	}
	// Create a new data product
	_, err = pc.CreateProduct(&product_sdk.ProductSetting{
		Name:        dataProduct,
		Description: "Schema test",
		Schema:      schema,
		Enabled:     true,
		Stream:      "",
	})
	if err != nil {
		panic(err)
	}
	return nil
}

func CreateRuleset(pc *product_sdk.ProductClient, dataProduct, ruleset, schemaJSON, event string) error {
	product, err := pc.GetProduct(dataProduct)
	if err != nil {
		return errors.New(fmt.Sprintf("Not found product %s", dataProduct))
	}

	if product.Setting.Rules == nil {
		product.Setting.Rules = make(map[string]*product_sdk.Rule)
	} else {

		// Check whether rule does exist or not
		_, ok := product.Setting.Rules[ruleset]
		if ok {
			return errors.New(fmt.Sprintf("Rule \"%s\" exists already\n", ruleset))
		}
	}

	var schema map[string]interface{}
	err = json.Unmarshal([]byte(schemaJSON), &schema)
	if err != nil {
		return errors.New("invalid schema format")
	}

	// Preparing a new rule
	rule := product_sdk.NewRule()
	rule.Name = ruleset
	rule.Product = dataProduct
	rule.UpdatedAt = time.Now()
	rule.CreatedAt = time.Now()

	// Unique ID
	id, _ := uuid.NewUUID()
	rule.ID = id.String()
	rule.Event = event
	rule.Method = "create"
	rule.PrimaryKey = []string{"id"}
	rule.Description = "Schema test"
	rule.Enabled = true
	rule.SchemaConfig = schema

	product.Setting.Rules[rule.Name] = rule

	_, err = pc.UpdateProduct(dataProduct, product.Setting)
	if err != nil {
		return err
	}
	return nil
}

func Publish(ac *adapter_sdk.AdapterConnector, eventName, payload string) error {
	_, err := ac.Publish(eventName, []byte(payload), nil)
	if err != nil {
		panic(err)
	}

	return nil
}

func processPayload(payload string) string {
	payload = ReplaceMassiveElementsStr(payload)
	payload = ReplaceMaxLenStr(payload)
	return payload
}

func ReplaceMassiveElementsStr(payload string) string {
	reMissive := regexp.MustCompile(`\[massive_elements\]`)
	if reMissive.MatchString(payload) {
		seqString := "["
		for i := 1; i <= 32768; i++ {
			if i > 1 {
				seqString += ", "
			}
			seqString += fmt.Sprintf("%d", i)
		}
		seqString += "]"
		payload = reMissive.ReplaceAllString(payload, seqString)
	}
	return payload
}

func ReplaceMaxLenStr(payload string) string {
	reMaxLenStr := regexp.MustCompile(`\[max_len_str\(\)\]`)
	if reMaxLenStr.MatchString(payload) {
		longString := strings.Repeat("a", 32768)
		payload = reMaxLenStr.ReplaceAllString(payload, longString)
	}
	return payload
}

func Subscribe(client *core.Client, dataProduct string) error {
	done := make(chan bool)
	// Create adapter connector
	acOpts := subscriber_sdk.NewOptions()
	acOpts.Domain = "default"
	acOpts.Verbose = true
	s := subscriber_sdk.NewSubscriberWithClient("", client, acOpts)
	// Subscribe to specific data product
	sub, err := s.Subscribe(dataProduct, func(msg *nats.Msg) {
		var pe gravity_sdk_types_product_event.ProductEvent
		err := proto.Unmarshal(msg.Data, &pe)
		if err != nil {
			fmt.Printf("Failed to parsing product event: %v", err)
			msg.Ack()
			return
		}

		r, err := pe.GetContent()
		if err != nil {
			fmt.Printf("Failed to parsing content: %v", err)
			msg.Ack()
			return
		}

		// Convert data to JSON
		receivePayload = r.AsMap()
		msg.Ack()
		done <- true

	}, subscriber_sdk.Partition(-1), subscriber_sdk.StartSequence(1))
	if err != nil {
		return err
	}
	select {
	case <-done:
		sub.Close()
	case <-time.After(5 * time.Second):
		sub.Close()
		return fmt.Errorf("%s subscribe timeout", dataProduct)
	}
	return nil
}

func LoadSchemaFromFile(schemaName, path string) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	schmeaString := string(data)
	ReplaceMaxLenStr(schmeaString)
	schemas[schemaName] = schmeaString
	return nil
}

func CheckConsistency(payload string) error {
	receivePayloadString, err := json.Marshal(receivePayload)
	if err != nil {
		return err
	}
	expectPayloadString := processPayload(payload)
	expectPayloadString = FormatJSONData(expectPayloadString)

	fmt.Println("receive:" + string(receivePayloadString))
	fmt.Println("expect:" + expectPayloadString)

	if string(receivePayloadString) != expectPayloadString {
		return errors.New("expect consistent but inconsistent")
	}
	return nil
}

func CheckInconsistency(payload string) error {
	receivePayloadString, err := json.Marshal(receivePayload)
	if err != nil {
		return err
	}
	expectPayloadString := FormatJSONData(payload)

	// fmt.Println(string(receivePayloadString))
	// fmt.Println(expectPayloadString)

	if string(receivePayloadString) == expectPayloadString {
		return errors.New("expect inconsistent but consistent")
	}
	return nil
}

func FormatJSONData(JSONData string) string {
	var JSON interface{}
	err := json.Unmarshal([]byte(JSONData), &JSON)
	if err != nil {
		log.Fatalf("%s Unmarshal Fail %s", JSONData, err.Error())
	}

	buf := new(bytes.Buffer)
	encoder := json.NewEncoder(buf)
	encoder.SetEscapeHTML(false)

	err = encoder.Encode(JSON)
	if err != nil {
		return err.Error()
	}
	return strings.Trim(buf.String(), "\n")
}

func CreateDataProductAndRuleset(dataProduct, ruleset, schemaName string) error {
	client := CreateClient()
	pcOpts := product_sdk.NewOptions()
	pcOpts.Domain = "default"
	productClient := product_sdk.NewProductClient(client, pcOpts)
	if err := CreateProduct(productClient, dataProduct, schemas[schemaName]); err != nil {
		return err
	}
	time.Sleep(10 * time.Millisecond)
	if err := CreateRuleset(productClient, dataProduct, ruleset, schemas[schemaName], ruleset); err != nil {
		return err
	}
	return nil
}

func CheckNatsService() error {
	nc, err := nats.Connect("nats://" + jetstreamURL)
	if err != nil {
		return err
	}
	defer nc.Close()
	return nil
}

func CheckDispatcherService() error {
	cli, err := client.NewClientWithOpts(client.FromEnv, client.WithAPIVersionNegotiation())
	if err != nil {
		return err
	}

	containers, err := cli.ContainerList(context.Background(), container.ListOptions{})
	if err != nil {
		return err
	}

	for _, container := range containers {
		if container.Names[0] == "/gravity-dispatcher" {
			return nil
		}
	}
	return errors.New("dispatcher container 不存在")
}

func ClearDataProducts() {
	nc, _ := nats.Connect("nats://" + jetstreamURL)
	defer nc.Close()

	js, err := nc.JetStream()
	if err != nil {
		log.Fatal(err)
	}

	streams := js.StreamNames(nats.MaxWait(200 * time.Second))

	re := regexp.MustCompile(`^GVT_default_DP_(.*)`)
	for stringName := range streams {
		if stringName == "GVT_default" {
			if err := js.PurgeStream(stringName); err != nil {
				log.Fatalf(err.Error())
			}
		}
		parts := re.FindStringSubmatch(stringName)
		if parts == nil {
			continue
		}
		productName := parts[1]
		cmd := exec.Command("../gravity-cli", "product", "delete", productName, "-s", jetstreamURL)
		if err := cmd.Run(); err != nil {
			log.Fatalf(err.Error())
		}
	}
}

func InitializeScenario(ctx *godog.ScenarioContext) {

	ctx.After(func(ctx context.Context, _ *godog.Scenario, _ error) (context.Context, error) {
		ClearDataProducts()
		return ctx, nil
	})
	ctx.Given(`^NATS has been opened$`, CheckNatsService)
	ctx.Given(`^Dispatcher has been opened$`, CheckDispatcherService)
	ctx.Given(`^Schema "'(.*?)'" from "'(.*?)'"$`, LoadSchemaFromFile)
	ctx.Given(`^Create data product "'(.*?)'" with ruleset "'(.*?)'" and the schema "'(.*?)'"$`, CreateDataProductAndRuleset)
	ctx.Given(`^Publish an Event to "'(.*?)'" with "'(.*?)'"$`, PublishEvent)
	ctx.When(`^Subscribe data product "'(.*?)'" using sdk$`, SubscribeDataProduct)
	ctx.Then(`^The received message and "'(.*?)'" are completely consistent in every field$`, CheckConsistency)
	ctx.Then(`^The received message and "'(.*?)'" are completely inconsistent in every field$`, CheckInconsistency)
	ctx.Given(`^Clear data products$`, ClearDataProducts)
}

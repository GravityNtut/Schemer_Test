package schemertest

import (
	"Schemer_Test/testutils"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"testing"
	"time"

	adapter_sdk "github.com/BrobridgeOrg/gravity-sdk/v2/adapter"
	"github.com/BrobridgeOrg/gravity-sdk/v2/core"
	product_sdk "github.com/BrobridgeOrg/gravity-sdk/v2/product"
	subscriber_sdk "github.com/BrobridgeOrg/gravity-sdk/v2/subscriber"
	gravity_sdk_types_product_event "github.com/BrobridgeOrg/gravity-sdk/v2/types/product_event"
	"github.com/cucumber/godog"
	"github.com/google/uuid"
	"github.com/nats-io/nats.go"
	"github.com/spf13/pflag"
	"google.golang.org/protobuf/proto"
)

var ut = testutils.TestUtils{}

var opts = godog.Options{
	Format:        "pretty",
	Paths:         []string{"./"},
	StopOnFailure: ut.Config.StopOnFailure,
}

func init() {
	godog.BindCommandLineFlags("godog.", &opts)
}

func TestMain(_ *testing.M) {
	pflag.Parse()
	err := ut.LoadConfig()
	if err != nil {
		log.Fatal(err)
	}
	suite := godog.TestSuite{
		ScenarioInitializer: InitializeScenario,
		Options:             &opts,
	}
	if suite.Run() != 0 {
		log.Fatal("non-zero status returned, failed to run feature tests")
	}
}

// func TestCreateProduct(t *testing.T) {
// 	if err := InitProduct(); err != nil {
// 		t.Errorf("CreateProduct() failed: %v", err)
// 	}
// }

// func TestPublish(t *testing.T) {
// 	// Create adapter connector
// 	client := CreateClient()
// 	acOpts := adapter_sdk.NewOptions()
// 	acOpts.Domain = "default"
// 	adapterClient := adapter_sdk.NewAdapterConnectorWithClient(client, acOpts)
// 	if err := Publish(adapterClient); err != nil {
// 		t.Errorf("Publish() failed: %v", err)
// 	}
// }

// func TestSubscribe(t *testing.T) {
// 	client := core.NewClient()
// 	options := core.NewOptions()
// 	client.Connect("0.0.0.0:32803", options)
// 	Subscribe(client)
// }

func CreateClient() *core.Client {
	client := core.NewClient()
	options := core.NewOptions()
	if err := client.Connect("0.0.0.0:32803", options); err != nil {
		panic(err)
	}
	return client
}

func InitProduct() error {
	// client := CreateClient()
	// pcOpts := product_sdk.NewOptions()
	// pcOpts.Domain = "default"
	// productClient := product_sdk.NewProductClient(client, pcOpts)


	return nil
}

func CreateProduct(pc *product_sdk.ProductClient, dataProduct, schemaPath string) error {
	schema, err := readSchemaFile(schemaPath)
	if err != nil {
		return err
	}
	// Create a new data product
	ps, err := pc.CreateProduct(&product_sdk.ProductSetting{
		Name:        dataProduct,
		Description: "Schema test",
		Schema:      schema,
		Enabled:     true,
		Stream:      "",
	})
	if err != nil {
		panic(err)
	}

	fmt.Println(ps.Name)
	return nil
}

func CreateRuleset(pc *product_sdk.ProductClient, dataProduct, ruleset, schemaPath, event string) error {
	product, err := pc.GetProduct(dataProduct)
	if err != nil {
		return errors.New(fmt.Sprintf("Not found product sdk_example"))
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

	schema, err := readSchemaFile(schemaPath)
	if err != nil {
		return err
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
	// rule.HandlerConfig = &product_sdk.HandlerConfig{
	// 	Type:   "script",
	// 	Script: "return source",
	// }

	product.Setting.Rules[rule.Name] = rule

	_, err = pc.UpdateProduct(dataProduct, product.Setting)
	if err != nil {
		return err
	}
	return nil
}

func readSchemaFile(filename string) (map[string]interface{}, error) {

	file, err := os.Open(filename)
	if err != nil {
		return nil, errors.New("No such schema file")
	}

	// Read file
	data, err := ioutil.ReadAll(file)
	if err != nil {
		return nil, err
	}

	var schema map[string]interface{}
	err = json.Unmarshal(data, &schema)
	if err != nil {

		return nil, errors.New("invalid schema format")
	}

	return schema, nil
}

func Publish(ac *adapter_sdk.AdapterConnector) error {
	meta := map[string]string{
		"example": "example",
	}
	_, err := ac.Publish("ruleEvent", []byte(`{"id":1,"name":"test","price":100,"kcal":50}`), meta)
	if err != nil {
		panic(err)
	}

	return nil
}

func Subscribe(client *core.Client) {
	// Create adapter connector
	acOpts := subscriber_sdk.NewOptions()
	acOpts.Domain = "default"
	acOpts.Verbose = true
	s := subscriber_sdk.NewSubscriberWithClient("", client, acOpts)
	// Subscribe to specific data product
	sub, err := s.Subscribe("sdk_example", func(msg *nats.Msg) {
		var pe gravity_sdk_types_product_event.ProductEvent
		err := proto.Unmarshal(msg.Data, &pe)
		if err != nil {
			fmt.Printf("Failed to parsing product event: %v", err)
			msg.Ack()
			return
		}

		md, _ := msg.Metadata()

		r, err := pe.GetContent()
		if err != nil {
			fmt.Printf("Failed to parsing content: %v", err)
			msg.Ack()
			return
		}

		// Convert data to JSON
		event := map[string]interface{}{
			"header":     msg.Header,
			"subject":    msg.Subject,
			"seq":        md.Sequence.Consumer,
			"timestamp":  md.Timestamp,
			"product":    "sdk_example",
			"event":      pe.EventName,
			"method":     pe.Method.String(),
			"table":      pe.Table,
			"primaryKey": pe.PrimaryKeys,
			"payload":    r.AsMap(),
		}

		data, _ := json.MarshalIndent(event, "", "  ")
		fmt.Println(string(data))
		msg.Ack()

	}, subscriber_sdk.Partition(-1), subscriber_sdk.StartSequence(1))
	if err != nil {
		panic(err)
	}
	time.Sleep(5 * time.Second)
	sub.Close()
}

func InitializeScenario(ctx *godog.ScenarioContext) {

	ctx.After(func(ctx context.Context, _ *godog.Scenario, _ error) (context.Context, error) {
		ut.ClearDataProducts()
		return ctx, nil
	})
	ctx.Given(`^NATS has been opened$`, ut.CheckNatsService)
	ctx.Given(`^Dispatcher has been opened$`, ut.CheckDispatcherService)
	ctx.Given(`^Create data product and ruleset$`, InitProduct)
	ctx.Given(`^Publish an Event with "'(.*?)'"$`, PublishEvent)
	ctx.Given(`^Subscribe data product "'(.*?)'" using sdk$`, SubscribeDataProduct)
	ctx.Given(`^The received message and expected result are completely consistent in every field$`, CheckConsistency)
	ctx.Given(`^The received message and expected result are completely inconsistent in every field$`, CheckInconsistency)

}

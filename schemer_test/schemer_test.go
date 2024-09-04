package schemertest

import (
	"encoding/json"
	"errors"
	"fmt"
	"testing"
	"time"

	adapter_sdk "github.com/BrobridgeOrg/gravity-sdk/v2/adapter"
	"github.com/BrobridgeOrg/gravity-sdk/v2/core"
	product_sdk "github.com/BrobridgeOrg/gravity-sdk/v2/product"
	"github.com/google/uuid"
)

func TestNewDeck(t *testing.T) {
	if err := InitApp(); err != nil {
		t.Errorf("CreateProduct() failed: %v", err)
	}
}

func InitApp() error {
	client := core.NewClient()
	options := core.NewOptions()
	err := client.Connect("0.0.0.0:32803", options)
	pcOpts := product_sdk.NewOptions()
	pcOpts.Domain = "default"
	productClient := product_sdk.NewProductClient(client, pcOpts)

	// Create adapter connector
	acOpts := adapter_sdk.NewOptions()
	acOpts.Domain = "default"
	adapterClient := adapter_sdk.NewAdapterConnectorWithClient(client, acOpts)

	if err != nil {
		panic(err)
	}
	if err = CreateProduct(productClient); err != nil {
		return err
	}
	if err = CreateRuleset(productClient); err != nil {
		return err
	}
	if err = Publish(adapterClient); err != nil {
		return err
	}

	return nil
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

func CreateRuleset(pc *product_sdk.ProductClient) error {
	product, err := pc.GetProduct("sdk_example")
	if err != nil {
		return errors.New(fmt.Sprintf("Not found product sdk_example"))
	}

	if product.Setting.Rules == nil {
		product.Setting.Rules = make(map[string]*product_sdk.Rule)
	} else {

		// Check whether rule does exist or not
		_, ok := product.Setting.Rules["ruleName"]
		if ok {
			return errors.New(fmt.Sprintf("Rule \"%s\" exists already\n", "ruleName"))
		}
	}

	schemaJson :=
		`
		{
			"id": { "type": "uint" },
			"name": { "type": "string" },
			"price": { "type": "uint" },
			"kcal": { "type": "uint" }
		}
	`

	var schema map[string]interface{}
	err = json.Unmarshal([]byte(schemaJson), &schema)
	if err != nil {
		return fmt.Errorf("invalid schema format")
	}
	// Preparing a new rule
	rule := product_sdk.NewRule()
	rule.Name = "ruleName"
	rule.Product = "sdk_example"
	rule.UpdatedAt = time.Now()
	rule.CreatedAt = time.Now()

	// Unique ID
	id, _ := uuid.NewUUID()
	rule.ID = id.String()
	rule.Event = "ruleEvent"
	rule.Method = "create"
	rule.PrimaryKey = []string{"id"}
	rule.Description = "ruleDescription"
	rule.Enabled = true
	rule.SchemaConfig = schema
	// rule.HandlerConfig = &product_sdk.HandlerConfig{
	// 	Type:   "script",
	// 	Script: "return source",
	// }

	product.Setting.Rules[rule.Name] = rule

	_, err = pc.UpdateProduct("sdk_example", product.Setting)
	if err != nil {
		return err
	}
	return nil
}

func CreateProduct(pc *product_sdk.ProductClient) error {
	schemaJson :=
		`
			{
				"id": { "type": "uint" },
				"name": { "type": "string" },
				"price": { "type": "uint" },
				"kcal": { "type": "uint" }
			}
		`

	var schema map[string]interface{}
	err := json.Unmarshal([]byte(schemaJson), &schema)
	if err != nil {
		return fmt.Errorf("invalid schema format")
	}
	// Create a new data product
	ps, err := pc.CreateProduct(&product_sdk.ProductSetting{
		Name:        "sdk_example",
		Description: "SDK Example",
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

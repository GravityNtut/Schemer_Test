package schemertest

import (
	"fmt"
	"testing"

	"github.com/BrobridgeOrg/gravity-sdk/v2/core"
	product_sdk "github.com/BrobridgeOrg/gravity-sdk/v2/product"
)

func TestNewDeck(t *testing.T) {
	client := core.NewClient()

	// Connect to Gravity
	options := core.NewOptions()
	err := client.Connect("0.0.0.0:32803", options)
	if err != nil {
		panic(err)
	}

	// Initializing data product client
	pcOpts := product_sdk.NewOptions()
	pcOpts.Domain = "default"
	productClient := product_sdk.NewProductClient(client, pcOpts)

	// Create a new data product
	ps, err := productClient.CreateProduct(&product_sdk.ProductSetting{
		Name:        "sdk_example",
		Description: "SDK Example",
		Enabled:     false,
		Stream:      "",
	})
	if err != nil {
		panic(err)
	}

	fmt.Println(ps.Name)

}

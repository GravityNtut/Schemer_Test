Feature: Schemer test 

Background: 
    Given NATS has been opened
    Given Dispatcher has been opened
    Given Schema "'normal_type_array_schema'" from "'./assets/array_schema1.json'"
    Given Schema "'special_type_array_schema'" from "'./assets/array_schema2.jso'n"
    Given Create data product "'drink_normal_type'" with ruleset "'drink_normal_type_rs'" and the schema "'normal_type_array_schema'"
    Given Create data product "'drink_special_type'" with ruleset "'drink_special_type_rs'" and the schema "'special_type_array_schema'"



@E4
	Scenario Outline:  Successful scenario for array
    Given Publish an Event with "'<payload>'"
    When Subscribe data product "'drink'" using sdk
    Then The received message and expected result are completely consistent in every field
    Examples:
    |   ID   | Schema       | Payload                         |
    |  E4(1)  |  ./assets/array_schema1.json   |  '{"id":1,"array_string":[]}'   |

@E5
	Scenario Outline:  Successful scenario for array
	Given Create data product "'drink'" with "'<schema>'"
    Given "'drink'" create ruleset "'drinkCreated'" with "'<schema>'"
    Given Publish an Event with "'<payload>'"
    When Subscribe data product "'drink'" using sdk
    Then The received message and expected result are completely inconsistent in every field
    Examples:
    |   ID   | schema       | payload                         |
    |  E5(1)  |  ./assets/array_schema2.json   |  '{"id":1,"array_string":""}'   |
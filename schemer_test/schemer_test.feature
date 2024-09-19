Feature: Schemer test 

Background: 
    Given NATS has been opened
    Given Dispatcher has been opened
    Given Schema "'normal_type_array_schema'" from "'./assets/array_schema1.json'"
    Given Schema "'special_type_array_schema'" from "'./assets/array_schema2.json'"
    Given Create data product "'drink_normal_type'" with ruleset "'drink_normal_type_rs'" and the schema "'normal_type_array_schema'"
    Given Create data product "'drink_special_type'" with ruleset "'drink_special_type_rs'" and the schema "'special_type_array_schema'"



@E4
	Scenario Outline:  Successful scenario for array
    Given Publish an Event to "'drink_normal_type_rs'" with "'<Payload>'"
    When Subscribe data product "'drink_normal_type'" using sdk
    # Then The received message and "'<Payload>'" are completely consistent in every field
    Examples:
    |   ID    |           Payload                        |
    |  E4(1)  |  {"id":1,"array_string":["a","b","c"]}   |

# @E5
# 	Scenario Outline:  Successful scenario for array
#     Given Publish an Event to "'drink_special_type_rs'" with "'<payload>'"
#     When Subscribe data product "'drink_special_type'" using sdk
#     # Then The received message and "'<Payload>'" are completely inconsistent in every field
    # Examples:
    # |   ID   | payload                         |
    # |  E5(1) |   {"id":2,"array_string":""}   |
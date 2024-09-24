Feature: Schemer test 

Background:    
    Given NATS has been opened
    Given Dispatcher has been opened
    Given Schema "'normal_type_array_schema'" from "'./assets/array_schema1.json'"
    Given Schema "'special_type_array_schema'" from "'./assets/array_schema2.json'"
    Given Schema "'wrong_subtype_array_schema'" from "'./assets/array_schema_wrong_subtype.json'"
    Given Create data product "'drink_normal_type'" with ruleset "'drink_normal_type_rs'" and the schema "'normal_type_array_schema'"
    Given Create data product "'drink_special_type'" with ruleset "'drink_special_type_rs'" and the schema "'special_type_array_schema'"
    Given Create data product "'drink_wrong_subtype'" with ruleset "'drink_wrong_subtype_rs'" and the schema "'wrong_subtype_array_schema'"



@E4
	Scenario Outline:  Successful scenario for array
    Given Publish an Event to "'drink_normal_type_rs'" with "'<Payload>'"
    When Subscribe data product "'drink_normal_type'" using sdk
    Then The received message and "'<Payload>'" are completely consistent in every field
    Examples:
    |   ID    |           Payload                        |
    |E4(1)	|{"id":1, "array_string":[]}|
    |E4(2)	|{"id":2, "array_int":[]}|
    |E4(3)	|{"id":3, "array_uint":[]}|
    |E4(4)	|{"id":4, "array_binary":[]}|
    |E4(5)	|{"id":5, "array_float":[]}|
    |E4(6)	|{"id":6, "array_bool":[]}|
    |E4(7)	|{"id":7, "array_time":[]}|
    |E4(8)	|{"id":8, "array_any":[]}|
    |E4(9)	|{"id":9, "array_string":["a", "b", "c"]}|
    # |E4(10)	|{"id":10, "array_any":["a", "b", "c"]}|
    # |E4(11)	|{"id":11, "array_int":[1, 2, 3]}|
    # |E4(12)	|{"id":12, "array_uint":[1, 2, 3]}| 
    # |E4(13)	|{"id":13, "array_float":[1, 2, 3]}|
    # |E4(14)	|{"id":14, "array_any":[1, 2, 3]}|
    |E4(15)	|{"id":15, "array_string":["00", "01", "10", "11"]}|
    # |E4(16)	|{"id":16, "array_binary":["00", "01", "10", "11"]}| 
    |E4(17)	|{"id":17, "array_any":["00", "01", "10", "11"]}|
    |E4(18)	|{"id":18, "array_float":[1.1, 2.2, 3.3]}|
    |E4(19)	|{"id":19, "array_any":[1.1, 2.2, 3.3]}|
    |E4(20)	|{"id":20, "array_bool":["True", "False"]}| 
    |E4(21)	|{"id":21, "array_any":["True", "False"]}| 
    |E4(22)	|{"id":22, "array_string":["2024-08-06T15:02:00Z", "2024-08-06T15:02:00Z", "2024-08-06T15:02:00Z"]}|
    # |E4(23)	|{"id":23, "array_time":["2024-08-06T15:02:00Z", "2024-08-06T15:02:00Z", "2024-08-06T15:02:00Z"]}| 
    |E4(24)	|{"id":24, "array_any":["2024-08-06T15:02:00Z", "2024-08-06T15:02:00Z", "2024-08-06T15:02:00Z"]}|
    |E4(25)	|{"id":25, "array_string":["[max_len_str()]", "[max_len_str()]", "[max_len_str()]"]}|
    |E4(26)	|{"id":26, "array_any":["[max_len_str()]", "[max_len_str()]", "[max_len_str()]"]}|
    # |E4(27)	|{"id":27, "array_int":[1]}|
    # |E4(28)	|{"id":28, "array_uint":[1]}|
    # |E4(29)	|{"id":29, "array_float":[1]}|
    # |E4(30)	|{"id":30, "array_any":[1]}|
    # |E4(31)	|{"id":31, "array_int":[massive_elements]}|
    # |E4(32)	|{"id":32, "array_uint":[massive_elements]}|
    # |E4(33)	|{"id":33, "array_float":[massive_elements]}|
    # |E4(34)	|{"id":34, "array_any":[massive_elements]}|
    # |E4(35)	|{"id":35, "array_int":[1, 1, 1]}|
    # |E4(36)	|{"id":36, "array_uint":[1, 1, 1]}|
    # |E4(37)	|{"id":37, "array_float":[1, 1, 1]}|
    # |E4(38)	|{"id":38, "array_any":[1, 1, 1]}|

@E5
	Scenario Outline:  Successful scenario for array
    Given Publish an Event to "'drink_special_type_rs'" with "'<Payload>'"
    When Subscribe data product "'drink_special_type'" using sdk
    Then The received message and "'<Payload>'" are completely inconsistent in every field
    Examples:
    |   ID   | Payload                         |
    |  E5(1) |   {"id":1,"array_string":""}   |

@E8
    Scenario Outline:  Successful scenario for array
    Given Publish an Event to "'drink_wrong_subtype_rs'" with "'<Payload>'"
    When Subscribe data product "'drink_wrong_subtype'" using sdk
    Examples:
    |   ID   | Payload                         |
    |  E8(1) |   {"id":3,"array_string":["a","b","c"]}   |

Feature: Schemer test 

Background:    
    Given NATS has been opened
    Given Dispatcher has been opened
    Given Schema "'normal_type_array_schema'" from "'./assets/array_schema1.json'"
    Given Schema "'special_type_array_schema'" from "'./assets/array_schema2.json'"
    Given Schema "'wrong_subtype_array_schema'" from "'./assets/array_schema_wrong_subtype.json'"
    Given Schema "'map_type1_schema'" from "'./assets/map_schema1.json'"
    Given Schema "'map_type2_schema'" from "'./assets/map_schema2.json'"
    Given Schema "'map_type3_schema'" from "'./assets/map_schema3.json'"
    Given Create data product "'drink_wrong_subtype'" with ruleset "'drink_wrong_subtype_rs'" and the schema "'wrong_subtype_array_schema'"
    Given Create data product "'drink_normal_type'" with ruleset "'drink_normal_type_rs'" and the schema "'normal_type_array_schema'"
    Given Create data product "'drink_special_type'" with ruleset "'drink_special_type_rs'" and the schema "'special_type_array_schema'"
    Given Create data product "'drink_map_type1'" with ruleset "'drink_map_type1_rs'" and the schema "'map_type1_schema'"
    Given Create data product "'drink_map_type2'" with ruleset "'drink_map_type2_rs'" and the schema "'map_type2_schema'"
    Given Create data product "'drink_map_type3'" with ruleset "'drink_map_type3_rs'" and the schema "'map_type3_schema'"

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
    |E4(10)	|{"id":10, "array_any":["a", "b", "c"]}|
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

@E6 
#Extension6
    Scenario Outline:  Success scenario for map schema test
    Given Publish an Event to "'<Ruleset>'" with "'<Payload>'"
    When Subscribe data product "'<DataProduct>'" using sdk
    Then The received message and "'<Payload>'" are completely consistent in every field
    Examples:
    |   ID   |    DataProduct   |      Ruleset        |              Payload                                                                                                                                                                                                             |
    |  E6(1) |  drink_map_type1 |  drink_map_type1_rs |    {"id": 1,"map_col":{}}                                                                                                                                                                                                        |
    |  E6(2) |  drink_map_type2 |  drink_map_type2_rs |    {"id": 2,"map_col":{"nested_time":"2024-08-06T15:02:00.123Z"}}                                                                                                                                                                |
    |  E6(3) |  drink_map_type3 |  drink_map_type3_rs |    {"id": 3,"map_col":{"string_col":"", "binary_col":"", "int_col": 5, "uint_col": 5, "float_col": 5, "bool_col": 0, "any_col": ""}}                                                                                             |
    |  E6(4) |  drink_map_type3 |  drink_map_type3_rs |    {"id": 4,"map_col":{"string_col":" ", "binary_col":" ", "int_col": 0, "uint_col": 0, "float_col": 1.23, "bool_col": "1", "any_col": " "}}                                                                                     |
    |  E6(5) |  drink_map_type3 |  drink_map_type3_rs |    {"id": 5,"map_col":{"string_col":"abc", "binary_col":"max_len(32768)", "int_col": -1, "uint_col": 5, "float_col": -1.23, "bool_col": false, "any_col": "abc"}}                                                                |
    |  E6(6) |  drink_map_type3 |  drink_map_type3_rs |    {"id": 6,"map_col":{"string_col":"中文", "binary_col":"0", "int_col": 5, "uint_col": 0, "float_col": -1.234567111111111, "bool_col": true, "any_col": "中文"}}                                                                 |
    |  E6(7) |  drink_map_type3 |  drink_map_type3_rs |    {"id": 7,"map_col":{"string_col":"!@#$%^&*()_+{}:<>?~`-=[]\;',.'/", "binary_col":"001", "int_col": 0, "uint_col": 5, "float_col": 1.234567111111111, "bool_col": 0, "any_col": "!@#$%^&*()_+{}:<>?~`-=[]\;',.'/"}}          |
    |  E6(8) |  drink_map_type3 |  drink_map_type3_rs |    {"id": 8,"map_col":{"string_col":"[max_len_str()]", "binary_col":"", "int_col": -1, "uint_col": 0, "float_col": 1.7976931348623157e+308, "bool_col": 1, "any_col": "[max_len_str()]"}}                                      |
    |  E6(9) |  drink_map_type3 |  drink_map_type3_rs |    {"id": 9,"map_col":{"string_col":"", "binary_col":" ", "int_col": 5, "uint_col": 5, "float_col": -1.7976931348623157e+308, "bool_col": false, "any_col": 5}}                                                                  | 
    |  E6(10)|  drink_map_type3 |  drink_map_type3_rs |    {"id": 10,"map_col":{"string_col":" ", "binary_col":"0", "int_col": 0, "uint_col": 0, "float_col": -0, "bool_col": true, "any_col": []}}                                                                                       |
    |  E6(11)|  drink_map_type3 |  drink_map_type3_rs |    {"id": 11,"map_col":{"string_col":"abc", "binary_col":"001", "int_col": -1, "uint_col": 5, "float_col": 5, "bool_col": 0, "any_col": {}}}                                                                                      |
    |  E6(12)|  drink_map_type3 |  drink_map_type3_rs |    {"id": 12,"map_col":{"string_col":"中文", "binary_col":"", "int_col": 5, "uint_col": 0, "float_col": 1.23, "bool_col": 1, "any_col": true}}                                                                                     |
    |  E6(13)|  drink_map_type3 |  drink_map_type3_rs |    {"id": 13,"map_col":{"string_col":"!@#$%^&*()_+{}:<>?~`-=[]\;',.'/", "binary_col":" ", "int_col": 0, "uint_col": 5, "float_col": -1.23, "bool_col": false, "any_col": null}}                                                  |

@E7
#Extension7
    Scenario Outline:  failure scenario for map schema test
    Given Publish an Event to "'<Ruleset>'" with "'<Payload>'"
    When Subscribe data product "'<DataProduct>'" using sdk
    Then The received message and expected result are completely inconsistent in every field
    Examples:
    |   ID   |    DataProduct   |     Ruleset        |              Payload                                                                                                                                                                                                                                                          |
    | E7(1)  |  drink_map_type1 |  drink_map_type1_rs |     {"id": 1,"map_col":""}                                                                                                                                                                                                                                                    |
    | E7(2)  |  drink_map_type1 |  drink_map_type1_rs |     {"id": 2,"map_col":" "}                                                                                                                                                                                                                                                   |
    | E7(3)  |  drink_map_type1 |  drink_map_type1_rs |     {"id": 3,"map_col":"abc"}                                                                                                                                                                                                                                                 |
    | E7(4)  |  drink_map_type1 |  drink_map_type1_rs |     {"id": 4,"map_col":"中文"}                                                                                                                                                                                                                                                |
    | E7(5)  |  drink_map_type1 |  drink_map_type1_rs |     {"id": 5,"map_col":"!@#$%^&*()_+{}:<>?~`-=[]\;',.'/"}                                                                                                                                                                                                                    |
    | E7(6)  |  drink_map_type1 |  drink_map_type1_rs |     {"id": 6,"map_col":"[max_len_str()]"}                                                                                                                                                                                                                               |
    | E7(7)  |  drink_map_type1 |  drink_map_type1_rs |     {"id": 7,"map_col":5}                                                                                                                                                                                                                                                     |
    | E7(8)  |  drink_map_type2 |  drink_map_type2_rs |     {"id": 8,"map_col":{"nested_time":"2024-08-06T15:02:00.1234567890Z"}}                                                                                                                                                                                                     |
    | E7(9)  |  drink_map_type3 |  drink_map_type3_rs |     {"id": 9,"map_col":{"string_col":5, "binary_col": "abc", "int_col": "", "uint_col": "", "float_col": "", "bool_col": ""}}                                                                                                                                                 |
    | E7(10) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 10,"map_col":{"string_col":5, "binary_col": "中文", "int_col": " ", "uint_col": " ", "float_col": " ", "bool_col": " "}}                                                                                                                                            |
    | E7(11) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 11,"map_col":{"string_col":5, "binary_col": "!@#$%^&*()_+{}:<>?~`-=[]\;',./", "int_col": "abc", "uint_col": "abc", "float_col": "abc", "bool_col": "abc"}}                                                                                                         |
    | E7(12) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 12,"map_col":{"string_col":5, "binary_col": 5, "int_col": "中文", "uint_col": "中文", "float_col": "中文", "bool_col": "中文"}}                                                                                                                                       |                                       
    | E7(13) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 13,"map_col":{"string_col":5, "binary_col": "10102", "int_col": "!@#$%^&*()_+{}:<>?~`-=[]\;',./", "uint_col": "!@#$%^&*()_+{}:<>?~`-=[]\;',./", "float_col": "!@#$%^&*()_+{}:<>?~`-=[]\;',./", "bool_col": "!@#$%^&*()_+{}:<>?~`-=[]\;',./"}}                      |
    | E7(14) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 14,"map_col":{"string_col":5, "binary_col": 101, "int_col": "[max_len_str()]", "uint_col": "[max_len_str()]", "float_col": "[max_len_str()]", "bool_col": "[max_len_str()]"}}                                                                   |
    | E7(15) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 15,"map_col":{"string_col":5, "binary_col": "abc", "int_col": 9223372036854775808, "uint_col": -1, "float_col": 1.0000000000000001, "bool_col": 5}}                                                                                                           |
    | E7(16) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 16,"map_col":{"string_col":5, "binary_col": "中文", "int_col": -9223372036854775809, "uint_col": 18446744073709551616, "float_col": "", "bool_col": ""}}                                                                                                |
    | E7(17) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 17,"map_col":{"string_col":5, "binary_col": "!@#$%^&*()_+{}:<>?~`-=[]\;',./", "int_col": 1.23, "uint_col": 1.23, "float_col": " ", "bool_col": " "}}                                                                                                                |
    | E7(18) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 18,"map_col":{"string_col":"abcde","string_col":"duplicate"}}                                                                                                                                                                                                       |
    | E7(19) |  drink_map_type3 |  drink_map_type3_rs |     {"id": 19,"map_col":{"abcde"}}                                                                                                                                                                                                                                            |


@E8
    Scenario Outline:  Successful scenario for array
    Given Publish an Event to "'drink_wrong_subtype_rs'" with "'<Payload>'"
    When Subscribe data product "'drink_wrong_subtype'" using sdk
    Examples:
    |   ID   | Payload                         |
    |  E8(1) |   {"id":3,"array_string":["a","b","c"]}   |

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

#Scenario
	Scenario Outline:  Successful scenario. Use the `product sub` command to receive all data published to the specified data product.
	Given Create data product "'drink'"
    Given Create data product "'drink'" with ruleset "'drinkCreated'"
    Given Publish an Event with payload '{"string":"'string'","binary":"'binary'","int":"'int'","uint":"'uint'","float":"'float'","bool":"'bool'","time":"'time'","time.precision":"'time.precision'","array":"'array'","array.subtype":"'array.subtype'","map":"'map'","any":"'any'"}' into sdk	
    # Given Set subscribe timeout with "'1'" second
    When Subscribe data product "'drink'"
    Then Get the subscribed message and publish message is matched
    Examples:
    | ID   | string                                | binary                | int                              | uint                           | float                   | bool                   | time | time.precision | array                                             | array.subtype                             | map                                | any                      |
    | M(1) | ""                                    | ""                    | "abc"                            | "中文"                         | "abc"                   | "abc"                  |      |                |                                                   |                                          |                                    | ""                        |
    | M(2) | " "                                   | " "                   | "中文"                           | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" | "中文"                  | "中文"                 |      |                |                                                   |                                          |                                    | " "                        |
    | M(3) | "abc"                                 | "abc"                 | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" | "中文"                         | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" |      |                |                                                   |                                          |                                    | "abc"                    |
    | M(4) | "中文"                                | "中文"                | "abc"                            | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" | "max_len_str(32768)"    | "max_len_str(32768)"   |      |                |                                                   |                                          |                                    | "中文"                   |
    | M(5) | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'"   | "max_len(32768)"      | "中文"                            | "中文"                         | "5"                     | "abc"                  |      |                |                                                   |                                          |                                    | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" |
    | M(6) | "max_len_str(32768)"                  | "5"                   | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" | "0"                     | "中文"                 |      |                |                                                   |                                          |                                    | "max_len_str(32768)"    |
    | M(7) | ""                                    | ""                    | "abc"                            | "中文"                         | "1.23"                  | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" |      |                |                                                   |                                          |                                    | "5"                      |
    | M(8) | " "                                   | " "                   | "中文"                           | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" | "1.234567111111111"     | "max_len_str(32768)"   |      |                | "[]"                                              |                                          |                                    | "1.234567111111111"     |



#Extension6
    @E6 
    Scenario Outline:  Success scenario for map schema test
    Given Create data product "'drink'" with "'<schema>'"
    Given Create data product "'drink'" with ruleset "'drinkCreated'" with "'<schema>'"
    Given Publish an Event with payload "'<payload>'" into sdk
    When Subscribe data product "'drink'" using the sdk
    Then The received message and expected result are completely consistent in every field
    Examples:
    |   ID   |      schema       |              payload                                                                                                                                                                                                             |
    |  E6(1) |  map_schema1.json |    {"id": 1,"map_col":{}}                                                                                                                                                                                                        |
    |  E6(2) |  map_schema2.json |    {"id": 1,"map_col":{"nested_time":"2024-08-06T15:02:00.123Z"}}                                                                                                                                                                |
    |  E6(3) |  map_schema3.json |    {"id": 1,"map_col":{"string_col":"", "binary_col":"", "int_col": 5, "uint_col": 5, "float_col": 5, "bool_col": 0, "any_col": ""}}                                                                                             |
    |  E6(4) |  map_schema3.json |    {"id": 1,"map_col":{"string_col":" ", "binary_col":" ", "int_col": 0, "uint_col": 0, "float_col": 1.23, "bool_col": "1", "any_col": " "}}                                                                                     |
    |  E6(5) |  map_schema3.json |    {"id": 1,"map_col":{"string_col":"abc", "binary_col":"max_len(32768)", "int_col": -1, "uint_col": 5, "float_col": -1.23, "bool_col": false, "any_col": "abc"}}                                                                |
    |  E6(6) |  map_schema3.json |    {"id": 1,"map_col":{"string_col":"中文", "binary_col":"0", "int_col": 5, "uint_col": 0, "float_col": -1.234567111111111, "bool_col": true, "any_col": "中文"}}                                                                 |
    |  E6(7) |  map_schema3.json |    {"id": 1,"map_col":{"string_col":"!@#$%^&*()_+{}|:<>?~`-=[]\;',./'", "binary_col":"001", "int_col": 0, "uint_col": 5, "float_col": 1.234567111111111, "bool_col": 0, "any_col": "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'"}}          |
    |  E6(8) |  map_schema3.json |    {"id": 1,"map_col":{"string_col":max_len_str(32768), "binary_col":"", "int_col": -1, "uint_col": 0, "float_col": 1.7976931348623157e+308, "bool_col": 1, "any_col": max_len_str(32768)}}                                      |
    |  E6(9) |  map_schema3.json |    {"id": 1,"map_col":{"string_col":"", "binary_col":" ", "int_col": 5, "uint_col": 5, "float_col": -1.7976931348623157e+308, "bool_col": false, "any_col": 5}}                                                                  | 
    |  E6(10)|  map_schema3.json |    {"id": 1,"map_col":{"string_col":" ", "binary_col":"0", "int_col": 0, "uint_col": 0, "float_col": -0, "bool_col": true, "any_col": []}}                                                                                       |
    |  E6(11)|  map_schema3.json |    {"id": 1,"map_col":{"string_col":"abc", "binary_col":"001", "int_col": -1, "uint_col": 5, "float_col": 5, "bool_col": 0, "any_col": {}}}                                                                                      |
    |  E6(12)|  map_schema3.json |    {"id": 1,"map_col":{"string_col":"中文", "binary_col":"", "int_col": 5, "uint_col": 0, "float_col": 1.23, "bool_col": 1, "any_col": true}}                                                                                     |
    |  E6(13)|  map_schema3.json |    {"id": 1,"map_col":{"string_col":"!@#$%^&*()_+{}|:<>?~`-=[]\;',./'", "binary_col":" ", "int_col": 0, "uint_col": 5, "float_col": -1.23, "bool_col": false, "any_col": null}}                                                  |

#Extension7
    @E7
    Scenario Outline:  failure scenario for map schema test
    Given Create data product "'drink'" with "'<schema>'"
    Given Create data product "'drink'" with ruleset "'drinkCreated'" with "'<schema>'"
    Given Publish an Event with payload "'<payload>'" into sdk
    When Subscribe data product "'drink'" using the sdk
    Then The received message and expected result are completely inconsistent in every field
    Examples:
    |   ID   |      schema       |              payload                                                                                                                                                                                                                                                          |
    | E7(1)  |  map_schema1.json |     {"id": 1,"map_col":""}                                                                                                                                                                                                                                                    |
    | E7(2)  |  map_schema1.json |     {"id": 1,"map_col":" "}                                                                                                                                                                                                                                                   |
    | E7(3)  |  map_schema1.json |     {"id": 1,"map_col":"abc"}                                                                                                                                                                                                                                                 |
    | E7(4)  |  map_schema1.json |     {"id": 1,"map_col":"中文"}                                                                                                                                                                                                                                                |
    | E7(5)  |  map_schema1.json |     {"id": 1,"map_col":"!@#$%^&*()_+{}|:<>?~`-=[]\;',./'"}                                                                                                                                                                                                                    |
    | E7(6)  |  map_schema1.json |     {"id": 1,"map_col":max_len_str(32768)}                                                                                                                                                                                                                                    |
    | E7(7)  |  map_schema1.json |     {"id": 1,"map_col":5}                                                                                                                                                                                                                                                     |
    | E7(8)  |  map_schema2.json |     {"id": 1,"map_col":{"nested_time":"2024-08-06T15:02:00.1234567890Z"}}                                                                                                                                                                                                     |
    | E7(9)  |  map_schema3.json |     {"id": 1,"map_col":{"string_col":5, "binary_col": "abc", "int_col": "", "uint_col": "", "float_col": "", "bool_col": ""}}                                                                                                                                                 |
    | E7(10) |  map_schema3.json |     {"id": 1,"map_col":{"string_col":5, "binary_col": "中文", "int_col": " ", "uint_col": " ", "float_col": " ", "bool_col": " "}}                                                                                                                                            |
    | E7(11) |  map_schema3.json |     {"id": 1,"map_col":{"string_col":5, "binary_col": "!@#$%^&*()_+{}|:<>?~`-=[]\;',./", "int_col": "abc", "uint_col": "abc", "float_col": "abc", "bool_col": "abc"}}                                                                                                         |
    | E7(12) |  map_schema3.json |     {"id": 1,"map_col":{"string_col":5, "binary_col": 5, "int_col": "中文", "uint_col": "中文", "float_col": "中文", "bool_col": "中文"}}                                                                                                                                       |                                       
    | E7(13) |  map_schema3.json |     {"id": 1,"map_col":{"string_col":5, "binary_col": "10102", "int_col": "!@#$%^&*()_+{}|:<>?~`-=[]\;',./", "uint_col": "!@#$%^&*()_+{}|:<>?~`-=[]\;',./", "float_col": "!@#$%^&*()_+{}|:<>?~`-=[]\;',./", "bool_col": "!@#$%^&*()_+{}|:<>?~`-=[]\;',./"}}                   |
    | E7(14) |  map_schema3.json |     {"id": 1,"map_col":{"string_col":5, "binary_col": 101, "int_col": max_len_str(32768), "uint_col": max_len_str(32768), "float_col": max_len_str(32768), "bool_col": max_len_str(32768)}}                                                                                   |
    | E7(15) |  map_schema3.json |     {"id": 1,"map_col":{"string_col":5, "binary_col": "abc", "int_col": 9,223,372,036,854,775,808, "uint_col": -1, "float_col": 1.0000000000000001, "bool_col": 5}}                                                                                                           |
    | E7(16) |  map_schema3.json |     {"id": 1,"map_col":{"string_col":5, "binary_col": "中文", "int_col": -9,223,372,036,854,775,809, "uint_col": 18,446,744,073,709,551,616, "float_col": "", "bool_col": ""}}                                                                                                |
    | E7(17) |  map_schema3.json |     {"id": 1,"map_col":{"string_col":5, "binary_col": "!@#$%^&*()_+{}|:<>?~`-=[]\;',./", "int_col": 1.23, "uint_col": 1.23, "float_col": " ", "bool_col": " "}}                                                                                                               |
    | E7(18) |  map_schema3.json |     {"id": 1,"map_col":{"string_col":"abcde","string_col":"duplicate"}}                                                                                                                                                                                                       |
    | E7(19) |  map_schema3.json |     {"id": 1,"map_col":{"abcde"}}                                                                                                                                                                                                                                            |
Feature: Schemer test 

Scenario:
Given NATS has been opened
Given Dispatcher has been opened
#Scenario
	Scenario Outline: Successful scenario for normal data type.
	Given Create data product "'drink'" with "'<schema>'"
    Given Create data product "'drink'" with ruleset "'drinkCreated'" and the schema "'<schema>'"
    Given Publish an Event with payload '{"string":"'string'","binary":"'binary'","int":"'int'","uint":"'uint'","float":"'float'","bool":"'bool'","time":"'time'","time.precision":"'time.precision'","array":"'array'","array.subtype":"'array.subtype'","map":"'map'","any":"'any'"}' into sdk	
    # Given Set subscribe timeout with "'1'" second
    When Subscribe data product "'drink'" using the sdk
    Then The received message and expected result are completely consistent in every field
    Examples:
    | ID   | string                                | binary                | int                              | uint                           | float                      | bool                   | time | time.precision | array                                             | array.subtype                             | map                                | any                                |
    | M(1) | ""                                    | ""                    | "5"                              | "5"                            | "5"                        | "0"                    |      |                |                                                   |                                           |                                    | ""                                 |
    | M(2) | " "                                   | " "                   | "0"                              | "0"                            | "1.23"                     | "1"                    |      |                |                                                   |                                           |                                    | " "                                |
    | M(3) | "abc"                                 | "max_len(32768)"      | "-1"                             | "5"                            | "-1.23"                    | "false"                |      |                |                                                   |                                           |                                    | "abc"                              |
    | M(4) | "中文"                                | "0"                   | "5"                              | "0"                            | "-1.234567111111111"       | "true"                 |      |                |                                                   |                                           |                                    | "中文"                             |
    | M(5) | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'"    | "001"                 | "0"                              | "5"                            | "-1.234567111111111"       | "0"                    |      |                |                                                   |                                           |                                    | "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'" |
    | M(6) | "max_len_str(32768)"                  | ""                    | "-1"                             | "0"                            | "1.7976931348623157e+308"  | "1"                    |      |                |                                                   |                                           |                                    | "max_len_str(32768)"               |
    | M(7) | ""                                    | " "                   | "5"                              | "5"                            | "-1.7976931348623157e+308" | "false"                |      |                |                                                   |                                           |                                    | "5"                                |
    | M(8) | " "                                   | "0"                   | "0"                              | "0"                            | "-0"                       | "true"                 |      |                |                                                   |                                           |                                    | "[]"                               |
    | M(9) | "abc"                                 | "001"                 | "-1"                             | "5"                            | "5"                        | "0"                    |      |                |                                                   |                                           |                                    | "{}"                               |
    | M(10)| "中文"                                | ""                    | "5"                              | "0"                            | "1.23"                     | "1"                    |      |                |                                                   |                                           |                                    | "true"                             |
    | M(11)| "!@#$%^&*()_+{}|:<>?~`-=[]\;',./'"    | " "                   | "0"                              | "5"                            | "-1.23"                    | "false"                |      |                |                                                   |                                           |                                    | "null"                             |


#Scenario
	Scenario Outline: Failure scenario. Use the `product sub` command to receive all data published to the specified data product.
	Given Create data product "'drink'"
    Given Create data product "'drink'" with ruleset "'drinkCreated'"
    Given Publish 10 Events
    When Subscribe data product "'<ProductName>'" using parameters "'<SubName>'" "'<Partitions>'" "'<Seq>'"
    Then The CLI returns exit code 1
    Examples:
    |   ID   | ProductName | SubName    |   Partitions   |      Seq      |
    |  E1(1) |   notExist  |            |      -1        |       1       |
    |  E1(2) |     drink   |            |    notNumber   |       1       |
    |  E1(3) |     drink   |            |      0.1       |       1       |
    |  E1(4) |     drink   |            |      ,         |       1       |
    |  E1(5) |     drink   |            |    abc,200     |       1       |
    |  E1(6) |     drink   |            |      ""        |       1       |
    |  E1(7) |     drink   |            |      -1        |       0       |
    |  E1(8) |     drink   |            |      -1        |      -1       |  
    |  E1(9) |     drink   |            |      -1        |   notNumber   | 
    |  E1(10)|     drink   |            |      -1        |      0.1      |
    |  E1(11)|     drink   |            |      -1        |      ""       | 
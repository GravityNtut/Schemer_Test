Feature: Data Product subscribe 

Scenario:
Given NATS has been opened
Given Dispatcher has been opened
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
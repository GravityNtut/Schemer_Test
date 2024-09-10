Feature: Schemer test 

Scenario:
Given NATS has been opened
Given Dispatcher has been opened
#Scenario
	Scenario Outline:  Success scenario for time and time precision.							
	Given Create data product "'drink'" with "'<schema>'" 
    Given "'drink'" create ruleset "'drinkCreated'" with "'<schema>'"		
    Given Publish an Event with payload "'<payload>'" into sdk	
    When Subscribe data product "'drink'" using the sdk	
    Then The received message and expected result are completely consistent in every field
    Examples:
    |  ID  | schema | payload |
    | E2(1) | ./assets/time_precision_schema.json | '{"id":1,"time_second":"2024-08-06T15:02:00Z"}' |
    | E2(2) | ./assets/time_precision_schema.json | '{"id":2,"time_millisecond":"2024-08-06T15:02:00Z"}' |
    | E2(3) | ./assets/time_precision_schema.json | '{"id":3,"time_millisecond":"2024-08-06T15:02:00.123Z"}' |
    | E2(4) | ./assets/time_precision_schema.json | '{"id":4,"time_microsecond":"2024-08-06T15:02:00Z"}' |
    | E2(5) | ./assets/time_precision_schema.json | '{"id":5,"time_microsecond":"2024-08-06T15:02:00.123Z"}' |
    | E2(6) | ./assets/time_precision_schema.json | '{"id":6,"time_microsecond":"2024-08-06T15:02:00.123456Z"}' |
    | E2(7) | ./assets/time_precision_schema.json | '{"id":7,"time_nanosecond":"2024-08-06T15:02:00Z"}' |
    | E2(8) | ./assets/time_precision_schema.json | '{"id":8,"time_nanosecond":"2024-08-06T15:02:00.123Z"}' |
    | E2(9) | ./assets/time_precision_schema.json | '{"id":9,"time_nanosecond":"2024-08-06T15:02:00.123456Z"}' |
    | E2(10) | ./assets/time_precision_schema.json | '{"id":10,"time_nanosecond":"2024-08-06T15:02:00.123456789Z"}' |
    | E2(11) | ./assets/time_precision_schema.json | '{"id":10,"time_default":"2024-08-06T15:02:00Z"}' |
    | E2(12) | ./assets/time_precision_schema.json | '{"id":10,"time_default":"2024-08-06T15:02:00.123Z"}' |

#Scenario
	Scenario Outline: Failure scenario for time and time precision.
	Given Create data product "'drink'" with "'<schema>'" 
    Given "'drink'" create ruleset "'drinkCreated'" with "'<schema>'"		
    Given Publish an Event with payload "'<payload>'" into sdk	
    When Subscribe data product "'drink'" using the sdk	
    Then The received message and expected result are completely inconsistent in every field
    Examples:
    | ID   | schema                | payload |
    | E3(1) | ./assets/time_precision_schema.json | '{"id":1,"time_":""}' |
    | E3(2) | ./assets/time_precision_schema.json | '{"id":2,"time_":" "}' |
    | E3(3) | ./assets/time_precision_schema.json | '{"id":3,"time_":"abc"}' |
    | E3(4) | ./assets/time_precision_schema.json | '{"id":4,"time_":"中文"}' |
    | E3(5) | ./assets/time_precision_schema.json | '{"id":5,"time_":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(6) | ./assets/time_precision_schema.json | '{"id":6,"time_":"max_len_str(32768)"}' |
    | E3(7) | ./assets/time_precision_schema.json | '{"id":7,"time_":5}' |
    | E3(8) | ./assets/time_precision_schema.json | '{"id":8,"time_":"2024-08-06T15:02:00Z"}' |
    | E3(9) | ./assets/time_precision_schema.json | '{"id":9,"time_":"2024-08-06T15:02:00.123Z"}' |
    | E3(10) | ./assets/time_precision_schema.json | '{"id":10,"time_":"2024-08-06T15:02:00.123456Z"}' |
    | E3(11) | ./assets/time_precision_schema.json | '{"id":11,"time_":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(12) | ./assets/time_precision_schema.json | '{"id":12,"time_":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(13) | ./assets/time_precision_schema.json | '{"id":13,"time_ ":""}' |
    | E3(14) | ./assets/time_precision_schema.json | '{"id":14,"time_ ":" "}' |
    | E3(15) | ./assets/time_precision_schema.json | '{"id":15,"time_ ":"abc"}' |
    | E3(16) | ./assets/time_precision_schema.json | '{"id":16,"time_ ":"中文"}' |
    | E3(17) | ./assets/time_precision_schema.json | '{"id":17,"time_ ":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(18) | ./assets/time_precision_schema.json | '{"id":18,"time_ ":"max_len_str(32768)"}' |
    | E3(19) | ./assets/time_precision_schema.json | '{"id":19,"time_ ":5}' |
    | E3(20) | ./assets/time_precision_schema.json | '{"id":20,"time_ ":"2024-08-06T15:02:00Z"}' |
    | E3(21) | ./assets/time_precision_schema.json | '{"id":21,"time_ ":"2024-08-06T15:02:00.123Z"}' |
    | E3(22) | ./assets/time_precision_schema.json | '{"id":22,"time_ ":"2024-08-06T15:02:00.123456Z"}' |
    | E3(23) | ./assets/time_precision_schema.json | '{"id":23,"time_ ":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(24) | ./assets/time_precision_schema.json | '{"id":24,"time_ ":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(25) | ./assets/time_precision_schema.json | '{"id":25,"time_abc":""}' |
    | E3(26) | ./assets/time_precision_schema.json | '{"id":26,"time_abc":" "}' |
    | E3(27) | ./assets/time_precision_schema.json | '{"id":27,"time_abc":"abc"}' |
    | E3(28) | ./assets/time_precision_schema.json | '{"id":28,"time_abc":"中文"}' |
    | E3(29) | ./assets/time_precision_schema.json | '{"id":29,"time_abc":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(30) | ./assets/time_precision_schema.json | '{"id":30,"time_abc":"max_len_str(32768)"}' |
    | E3(31) | ./assets/time_precision_schema.json | '{"id":31,"time_abc":5}' |
    | E3(32) | ./assets/time_precision_schema.json | '{"id":32,"time_abc":"2024-08-06T15:02:00Z"}' |
    | E3(33) | ./assets/time_precision_schema.json | '{"id":33,"time_abc":"2024-08-06T15:02:00.123Z"}' |
    | E3(34) | ./assets/time_precision_schema.json | '{"id":34,"time_abc":"2024-08-06T15:02:00.123456Z"}' |
    | E3(35) | ./assets/time_precision_schema.json | '{"id":35,"time_abc":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(36) | ./assets/time_precision_schema.json | '{"id":36,"time_abc":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(37) | ./assets/time_precision_schema.json | '{"id":37,"time_中文":""}' |
    | E3(38) | ./assets/time_precision_schema.json | '{"id":38,"time_中文":" "}' |
    | E3(39) | ./assets/time_precision_schema.json | '{"id":39,"time_中文":"abc"}' |
    | E3(40) | ./assets/time_precision_schema.json | '{"id":40,"time_中文":"中文"}' |
    | E3(41) | ./assets/time_precision_schema.json | '{"id":41,"time_中文":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(42) | ./assets/time_precision_schema.json | '{"id":42,"time_中文":"max_len_str(32768)"}' |
    | E3(43) | ./assets/time_precision_schema.json | '{"id":43,"time_中文":5}' |
    | E3(44) | ./assets/time_precision_schema.json | '{"id":44,"time_中文":"2024-08-06T15:02:00Z"}' |
    | E3(45) | ./assets/time_precision_schema.json | '{"id":45,"time_中文":"2024-08-06T15:02:00.123Z"}' |
    | E3(46) | ./assets/time_precision_schema.json | '{"id":46,"time_中文":"2024-08-06T15:02:00.123456Z"}' |
    | E3(47) | ./assets/time_precision_schema.json | '{"id":47,"time_中文":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(48) | ./assets/time_precision_schema.json | '{"id":48,"time_中文":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(49) | ./assets/time_precision_schema.json | '{"id":49,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":""}' |
    | E3(50) | ./assets/time_precision_schema.json | '{"id":50,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":" "}' |
    | E3(51) | ./assets/time_precision_schema.json | '{"id":51,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"abc"}' |
    | E3(52) | ./assets/time_precision_schema.json | '{"id":52,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"中文"}' |
    | E3(53) | ./assets/time_precision_schema.json | '{"id":53,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(54) | ./assets/time_precision_schema.json | '{"id":54,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"max_len_str(32768)"}' |
    | E3(55) | ./assets/time_precision_schema.json | '{"id":55,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"5"}' |
    | E3(56) | ./assets/time_precision_schema.json | '{"id":56,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"2024-08-06T15:02:00Z"}' |
    | E3(57) | ./assets/time_precision_schema.json | '{"id":57,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"2024-08-06T15:02:00.123Z"}' |
    | E3(58) | ./assets/time_precision_schema.json | '{"id":58,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"2024-08-06T15:02:00.123456Z"}' |
    | E3(59) | ./assets/time_precision_schema.json | '{"id":59,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(60) | ./assets/time_precision_schema.json | '{"id":60,"time_!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(61) | ./assets/time_precision_schema.json | '{"id":61,"time_max_len_str(32768)":""}' |
    | E3(62) | ./assets/time_precision_schema.json | '{"id":62,"time_max_len_str(32768)":" "}' |
    | E3(63) | ./assets/time_precision_schema.json | '{"id":63,"time_max_len_str(32768)":"abc"}' |
    | E3(64) | ./assets/time_precision_schema.json | '{"id":64,"time_max_len_str(32768)":"中文"}' |
    | E3(65) | ./assets/time_precision_schema.json | '{"id":65,"time_max_len_str(32768)":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(66) | ./assets/time_precision_schema.json | '{"id":66,"time_max_len_str(32768)":"max_len_str(32768)"}' |
    | E3(67) | ./assets/time_precision_schema.json | '{"id":67,"time_max_len_str(32768)":5}' |
    | E3(68) | ./assets/time_precision_schema.json | '{"id":68,"time_max_len_str(32768)":"2024-08-06T15:02:00Z"}' |
    | E3(69) | ./assets/time_precision_schema.json | '{"id":69,"time_max_len_str(32768)":"2024-08-06T15:02:00.123Z"}' |
    | E3(70) | ./assets/time_precision_schema.json | '{"id":70,"time_max_len_str(32768)":"2024-08-06T15:02:00.123456Z"}' |
    | E3(71) | ./assets/time_precision_schema.json | '{"id":71,"time_max_len_str(32768)":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(72) | ./assets/time_precision_schema.json | '{"id":72,"time_max_len_str(32768)":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(73) | ./assets/time_precision_schema.json | '{"id":73,"time_5":""}' |
    | E3(74) | ./assets/time_precision_schema.json | '{"id":74,"time_5":" "}' |
    | E3(75) | ./assets/time_precision_schema.json | '{"id":75,"time_5":"abc"}' |
    | E3(76) | ./assets/time_precision_schema.json | '{"id":76,"time_5":"中文"}' |
    | E3(77) | ./assets/time_precision_schema.json | '{"id":77,"time_5":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(78) | ./assets/time_precision_schema.json | '{"id":78,"time_5":"max_len_str(32768)"}' |
    | E3(79) | ./assets/time_precision_schema.json | '{"id":79,"time_5":5}' |
    | E3(80) | ./assets/time_precision_schema.json | '{"id":80,"time_5":"2024-08-06T15:02:00Z"}' |
    | E3(81) | ./assets/time_precision_schema.json | '{"id":81,"time_5":"2024-08-06T15:02:00.123Z"}' |
    | E3(82) | ./assets/time_precision_schema.json | '{"id":82,"time_5":"2024-08-06T15:02:00.123456Z"}' |
    | E3(83) | ./assets/time_precision_schema.json | '{"id":83,"time_5":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(84) | ./assets/time_precision_schema.json | '{"id":84,"time_5":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(85) | ./assets/time_precision_schema.json | '{"id":85,"time_second":""}' |
    | E3(86) | ./assets/time_precision_schema.json | '{"id":86,"time_second":" "}' |
    | E3(87) | ./assets/time_precision_schema.json | '{"id":87,"time_second":"abc"}' |
    | E3(88) | ./assets/time_precision_schema.json | '{"id":88,"time_second":"中文"}' |
    | E3(89) | ./assets/time_precision_schema.json | '{"id":89,"time_second":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(90) | ./assets/time_precision_schema.json | '{"id":90,"time_second":"max_len_str(32768)"}' |
    | E3(91) | ./assets/time_precision_schema.json | '{"id":91,"time_second":5}' |
    | E3(92) | ./assets/time_precision_schema.json | '{"id":92,"time_second":"2024-08-06T15:02:00.123Z"}' |
    | E3(93) | ./assets/time_precision_schema.json | '{"id":93,"time_second":"2024-08-06T15:02:00.123456Z"}' |
    | E3(94) | ./assets/time_precision_schema.json | '{"id":94,"time_second":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(95) | ./assets/time_precision_schema.json | '{"id":95,"time_second":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(96) | ./assets/time_precision_schema.json | '{"id":96,"time_millisecond":""}' |
    | E3(97) | ./assets/time_precision_schema.json | '{"id":97,"time_millisecond":" "}' |
    | E3(98) | ./assets/time_precision_schema.json | '{"id":98,"time_millisecond":"abc"}' |
    | E3(99) | ./assets/time_precision_schema.json | '{"id":99,"time_millisecond":"中文"}' |
    | E3(100) | ./assets/time_precision_schema.json | '{"id":100,"time_millisecond":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(101) | ./assets/time_precision_schema.json | '{"id":101,"time_millisecond":"max_len_str(32768)"}' |
    | E3(102) | ./assets/time_precision_schema.json | '{"id":102,"time_millisecond":5}' |
    | E3(103) | ./assets/time_precision_schema.json | '{"id":103,"time_millisecond":"2024-08-06T15:02:00.123456Z"}' |
    | E3(104) | ./assets/time_precision_schema.json | '{"id":104,"time_millisecond":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(105) | ./assets/time_precision_schema.json | '{"id":105,"time_millisecond":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(106) | ./assets/time_precision_schema.json | '{"id":106,"time_microsecond":""}' |
    | E3(107) | ./assets/time_precision_schema.json | '{"id":107,"time_microsecond":" "}' |
    | E3(108) | ./assets/time_precision_schema.json | '{"id":108,"time_microsecond":"abc"}' |
    | E3(109) | ./assets/time_precision_schema.json | '{"id":109,"time_microsecond":"中文"}' |
    | E3(110) | ./assets/time_precision_schema.json | '{"id":110,"time_microsecond":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(111) | ./assets/time_precision_schema.json | '{"id":111,"time_microsecond":"max_len_str(32768)"}' |
    | E3(112) | ./assets/time_precision_schema.json | '{"id":112,"time_microsecond":5}' |
    | E3(113) | ./assets/time_precision_schema.json | '{"id":113,"time_microsecond":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(114) | ./assets/time_precision_schema.json | '{"id":114,"time_microsecond":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(115) | ./assets/time_precision_schema.json | '{"id":115,"time_nanosecond":""}' |
    | E3(116) | ./assets/time_precision_schema.json | '{"id":116,"time_nanosecond":" "}' |
    | E3(117) | ./assets/time_precision_schema.json | '{"id":117,"time_nanosecond":"abc"}' |
    | E3(118) | ./assets/time_precision_schema.json | '{"id":118,"time_nanosecond":"中文"}' |
    | E3(119) | ./assets/time_precision_schema.json | '{"id":119,"time_nanosecond":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(120) | ./assets/time_precision_schema.json | '{"id":120,"time_nanosecond":"max_len_str(32768)"}' |
    | E3(121) | ./assets/time_precision_schema.json | '{"id":121,"time_nanosecond":5}' |
    | E3(122) | ./assets/time_precision_schema.json | '{"id":122,"time_nanosecond":"2024-08-06T15:02:00.1234567890Z"}' |
    | E3(123) | ./assets/time_precision_schema.json | '{"id":123,"time_default":""}' |
    | E3(124) | ./assets/time_precision_schema.json | '{"id":124,"time_default":" "}' |
    | E3(125) | ./assets/time_precision_schema.json | '{"id":125,"time_default":"abc"}' |
    | E3(126) | ./assets/time_precision_schema.json | '{"id":126,"time_default":"中文"}' |
    | E3(127) | ./assets/time_precision_schema.json | '{"id":127,"time_default":"!@#$%^&*()_+{}|:<>?~`-=[]\\;\',./\'"}' |
    | E3(128) | ./assets/time_precision_schema.json | '{"id":128,"time_default":"max_len_str(32768)"}' |
    | E3(129) | ./assets/time_precision_schema.json | '{"id":129,"time_default":5}' |
    | E3(130) | ./assets/time_precision_schema.json | '{"id":130,"time_default":"2024-08-06T15:02:00.123456Z"}' |
    | E3(131) | ./assets/time_precision_schema.json | '{"id":131,"time_default":"2024-08-06T15:02:00.123456789Z"}' |
    | E3(132) | ./assets/time_precision_schema.json | '{"id":132,"time_default":"2024-08-06T15:02:00.1234567890Z"}' |
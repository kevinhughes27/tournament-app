BracketDb.define 'USAU_14.1' do
  name 'One team advances (USAU 14.1)'
  description 'Teams not in the bracket play a final game against their matching finish in the opposite pool
'
  teams '14'
  days '2'


{
  "games": [
    pool '7.1.1''A', [1,3,6,8,9,12,13]
    pool '7.1.1''B', [2,4,5,7,10,11,14]

    {"round":1, "bracket_uid":"a", "home_prereq":"A1", "away_prereq":"B2"},
    {"round":1, "bracket_uid":"b", "home_prereq":"B1", "away_prereq":"A2"},

    {"round":2, "bracket_uid":"1", "home_prereq":"Wa", "away_prereq":"Wb"},
    {"round":2, "bracket_uid":"3", "home_prereq":"La", "away_prereq":"Lb"},

    {"round":1, "bracket_uid":"5", "home_prereq":"A3", "away_prereq":"B3"},
    {"round":1, "bracket_uid":"7", "home_prereq":"A4", "away_prereq":"B4"},
    {"round":1, "bracket_uid":"9", "home_prereq":"A5", "away_prereq":"B5"},
    {"round":1, "bracket_uid":"11", "home_prereq":"A6", "away_prereq":"B6"},
    {"round":1, "bracket_uid":"13", "home_prereq":"A7", "away_prereq":"B7"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "W3"},
    {"position":4, "prereq": "L3"},
    {"position":5, "prereq": "W5"},
    {"position":6, "prereq": "L5"},
    {"position":7, "prereq": "W7"},
    {"position":8, "prereq": "L7"},
    {"position":9, "prereq": "W9"},
    {"position":10, "prereq": "L9"},
    {"position":11, "prereq": "W11"},
    {"position":12, "prereq": "L11"},
    {"position":13, "prereq": "W13"},
    {"position":14, "prereq": "L13"}
  ]
}


end

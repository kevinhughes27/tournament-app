BracketDb.define 'POWER_POOLS_9' do
  name 'Power Pools'
  description 'The losers in the loser bracket play the bottom seed of the B pool for extra games.
'
  teams '9'
  days '2'


{
  "games": [
    pool '4.1''A', [1,2,3,4]
    pool '5.1.3''B', [5,6,7,8,9]

    {"round":1, "bracket_uid":"a", "home_prereq":"A1", "away_prereq":"A4"},
    {"round":1, "bracket_uid":"b", "home_prereq":"A2", "away_prereq":"A3"},

    {"round":2, "bracket_uid":"1", "home_prereq":"Wa", "away_prereq":"Wb"},
    {"round":2, "bracket_uid":"3", "home_prereq":"La", "away_prereq":"Lb"},


    {"round":1, "bracket_uid":"aa", "home_prereq":"B1", "away_prereq":"B4"},
    {"round":1, "bracket_uid":"bb", "home_prereq":"B2", "away_prereq":"B3"},

    {"round":2, "bracket_uid":"cc", "home_prereq":"Laa", "away_prereq":"B5"},

    {"round":3, "bracket_uid":"dd", "home_prereq":"Lbb", "away_prereq":"B5"},
    {"round":3, "bracket_uid":"5", "home_prereq":"Waa", "away_prereq":"Wbb"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "W3"},
    {"position":4, "prereq": "L3"},
    {"position":5, "prereq": "W5"},
    {"position":6, "prereq": "L5"},
    {"position":7, "prereq": "Laa"},
    {"position":8, "prereq": "Lbb"},
    {"position":9, "prereq": "B5"}
  ]
}


end

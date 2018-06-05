BracketDb.define '9_POOL_BRACKET' do
  name 'Two Pools and a Bracket'
  description 'Each team gets 2 games on Sunday.
'
  teams '9'
  days '2'


{
  "games": [
    pool '5.1.3''A', [1,3,6,8,9]
    pool '4.1''B', [2,4,5,7]

    {"round": 1, "bracket_uid":"a", "home_prereq":"B4", "away_prereq":"A5"},
    {"round": 1, "bracket_uid":"b", "home_prereq":"B3", "away_prereq":"A4"},

    {"round": 2, "bracket_uid":"c", "home_prereq":"A1", "away_prereq":"B2"},
    {"round": 2, "bracket_uid":"d", "home_prereq":"A3", "away_prereq":"Wa"},
    {"round": 2, "bracket_uid":"8", "home_prereq":"La", "away_prereq":"Lb"},

    {"round": 3, "bracket_uid":"e", "home_prereq":"A2", "away_prereq":"B1"},
    {"round": 3, "bracket_uid":"5", "home_prereq":"Wd", "away_prereq":"Wb"},

    {"round": 4, "bracket_uid":"1", "home_prereq":"Wc", "away_prereq":"We"},
    {"round": 4, "bracket_uid":"3", "home_prereq":"Lc", "away_prereq":"Le"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "W3"},
    {"position":4, "prereq": "L3"},
    {"position":5, "prereq": "W5"},
    {"position":6, "prereq": "L5"},
    {"position":7, "prereq": "Ld"},
    {"position":8, "prereq": "W8"},
    {"position":9, "prereq": "L8"}
  ]
}


end

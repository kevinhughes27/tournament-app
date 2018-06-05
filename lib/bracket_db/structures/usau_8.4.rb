BracketDb.define 'USAU_8.4' do
  name 'Four teams advance (USAU 8.4)'
  teams '8'
  days '2'


{
  "games": [
    pool '4.1''A', [1,4,5,8]
    pool '4.1''B', [2,3,6,7]

    {"round": 1, "bracket_uid":"1", "home_prereq":"A1", "away_prereq":"B1"},
    {"round": 1, "bracket_uid":"b", "home_prereq":"A2", "away_prereq":"B2"},
    {"round": 2, "bracket_uid":"2", "home_prereq":"L1", "away_prereq":"Wb"},

    {"round": 1, "bracket_uid":"d", "home_prereq":"A3", "away_prereq":"B4"},
    {"round": 1, "bracket_uid":"e", "home_prereq":"A4", "away_prereq":"B3"},
    {"round": 2, "bracket_uid":"f", "home_prereq":"Wd", "away_prereq":"We"},

    {"round": 3, "bracket_uid":"4", "home_prereq":"Lb", "away_prereq":"Wf"},
    {"round": 3, "bracket_uid":"7", "home_prereq":"Ld", "away_prereq":"Le"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "W2"},
    {"position":3, "prereq": "L2"},
    {"position":4, "prereq": "W4"},
    {"position":5, "prereq": "L4"},
    {"position":6, "prereq": "Lf"},
    {"position":7, "prereq": "W7"},
    {"position":8, "prereq": "L7"}
  ]
}


end

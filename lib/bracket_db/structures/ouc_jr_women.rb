BracketDb.define 'OUC_JR_WOMEN' do
  name 'Ontario Junior Women 2017'
  teams '6'
  days '2'


{
  "games": [
    pool '6.1.2''A', [1,2,3,4,5,6]

    {"round":1, "bracket_uid":"1", "home_prereq":"A1", "away_prereq":"A2"},
    {"round":1, "bracket_uid":"G2", "home_prereq":"A3", "away_prereq":"A4"},
    {"round":1, "bracket_uid":"G3", "home_prereq":"A5", "away_prereq":"A6"},

    {"round":2, "bracket_uid":"2", "home_prereq":"L1", "away_prereq":"WG2"},
    {"round":2, "bracket_uid":"4", "home_prereq":"LG2", "away_prereq":"WG3"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "W2"},
    {"position":3, "prereq": "L2"},
    {"position":4, "prereq": "W4"},
    {"position":5, "prereq": "L4"},
    {"position":6, "prereq": "LG3"}
  ]
}


end

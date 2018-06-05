BracketDb.define 'USAU_7.3' do
  name 'Three teams advance (USAU 7.3)'
  description 'Pool games are played over 2 days.
'
  teams '7'
  days '2'


{
  "games": [
    pool '7.1.1''A', [1,2,3,4,5,6,7]

    {"round":1, "bracket_uid":"1", "home_prereq":"A1", "away_prereq":"A2"},
    {"round":1, "bracket_uid":"b", "home_prereq":"A3", "away_prereq":"A6"},
    {"round":1, "bracket_uid":"c", "home_prereq":"A5", "away_prereq":"A4"},

    {"round":2, "bracket_uid":"3", "home_prereq":"Wb", "away_prereq":"Wc"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "W3"},
    {"position":4, "prereq": "L3"},
    {"position":5, "prereq": "Lb"},
    {"position":6, "prereq": "Lc"},
    {"position":7, "prereq": "A7"}
  ]
}


end

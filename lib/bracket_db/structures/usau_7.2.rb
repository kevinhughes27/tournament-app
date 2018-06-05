BracketDb.define 'USAU_7.2' do
  name 'Two teams advance (USAU 7.2)'
  description 'Pool games are played over 2 days.
'
  teams '7'
  days '2'


{
  "games": [
    pool '7.1.1''A', [1,2,3,4,5,6,7]

    {"round":1, "bracket_uid":"1", "home_prereq":"A1", "away_prereq":"A2"},
    {"round":1, "bracket_uid":"b", "home_prereq":"A3", "away_prereq":"A4"},

    {"round":2, "bracket_uid":"2", "home_prereq":"Wb", "away_prereq":"L1"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "W2"},
    {"position":3, "prereq": "L2"},
    {"position":4, "prereq": "Lb"},
    {"position":5, "prereq": "A5"},
    {"position":6, "prereq": "A6"},
    {"position":7, "prereq": "A7"}
  ]
}


end

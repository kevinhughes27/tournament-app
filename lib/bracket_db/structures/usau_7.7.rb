BracketDb.define 'USAU_7.7' do
  name 'Seven teams advance (USAU 7.7)'
  description 'Pool games are played over 2 days.
'
  teams '7'
  days '2'


{
  "games": [
    pool '7.1.1''A', [1,2,3,4,5,6,7]

    {"round":1, "bracket_uid":"a", "home_prereq":"A1", "away_prereq":"A4"},
    {"round":1, "bracket_uid":"b", "home_prereq":"A2", "away_prereq":"A3"},

    {"round":2, "bracket_uid":"1", "home_prereq":"Wa", "away_prereq":"Wb"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "La"},
    {"position":4, "prereq": "Lb"},
    {"position":5, "prereq": "A5"},
    {"position":6, "prereq": "A6"},
    {"position":7, "prereq": "A7"}
  ]
}


end

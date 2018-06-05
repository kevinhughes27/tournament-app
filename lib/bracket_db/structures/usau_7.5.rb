BracketDb.define 'USAU_7.5' do
  name 'Five teams advance (USAU 7.5)'
  description 'Pool games are played over 2 days. 3rd place is determined from pool play.
'
  teams '7'
  days '2'


{
  "games": [
    pool '7.1.2''A', [1,2,3,4,5,6,7]

    {"round":1, "bracket_uid":"1", "home_prereq":"A1", "away_prereq":"A2"},
    {"round":1, "bracket_uid":"4", "home_prereq":"A4", "away_prereq":"A5"},
    {"round":1, "bracket_uid":"d", "home_prereq":"A6", "away_prereq":"A7"},

    {"round":2, "bracket_uid":"5", "home_prereq":"L4", "away_prereq":"Wd"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "A3"},
    {"position":4, "prereq": "W4"},
    {"position":5, "prereq": "W5"},
    {"position":6, "prereq": "L5"},
    {"position":7, "prereq": "Ld"}
  ]
}


end

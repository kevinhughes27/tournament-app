BracketDb.define 'USAU_7.4' do
  name 'Four teams advance (USAU 7.4)'
  description 'Pool games are played over 2 days.
'
  teams '7'
  days '2'


{
  "games": [
    pool '7.1.1''A', [1,2,3,4,5,6,7]

    {"round":1, "bracket_uid":"1", "home_prereq":"A1", "away_prereq":"A2"},
    {"round":1, "bracket_uid":"b", "home_prereq":"A3", "away_prereq":"A4"},
    {"round":1, "bracket_uid":"d", "home_prereq":"A5", "away_prereq":"A6"},

    {"round":2, "bracket_uid":"2", "home_prereq":"L1", "away_prereq":"Wb"},
    {"round":2, "bracket_uid":"4", "home_prereq":"Lb", "away_prereq":"Wd"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "W2"},
    {"position":3, "prereq": "L2"},
    {"position":4, "prereq": "W4"},
    {"position":5, "prereq": "L4"},
    {"position":6, "prereq": "Ld"},
    {"position":7, "prereq": "A7"}
  ]
}


end

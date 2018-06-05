BracketDb.define 'USAU_6.6' do
  name 'Six teams advance (USAU 6.6)'
  description 'Pool games are played to 13 and over 2 days.
'
  teams '6'
  days '2'


{
  "games": [
    pool '6.1.4''A', [1,2,3,4,5,6]

    {"round":1, "bracket_uid":"a", "home_prereq":"A1", "away_prereq":"A4"},
    {"round":1, "bracket_uid":"b", "home_prereq":"A2", "away_prereq":"A3"},
    {"round":1, "bracket_uid":"5", "home_prereq":"A5", "away_prereq":"A6"},

    {"round":2, "bracket_uid":"1", "home_prereq":"Wa", "away_prereq":"Wb"},
    {"round":2, "bracket_uid":"3", "home_prereq":"La", "away_prereq":"Lb"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "W3"},
    {"position":4, "prereq": "L3"},
    {"position":5, "prereq": "W5"},
    {"position":6, "prereq": "L5"}
  ]
}


end

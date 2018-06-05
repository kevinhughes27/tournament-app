BracketDb.define 'USAU_5.4' do
  name 'Four teams advance (USAU 5.4)'
  description 'The top team is determined on the first day, and that team has no games the second day.
'
  teams '5'
  days '2'


{
  "games": [
    pool '5.1.2''A', [1,2,3,4,5]

    {"round":1, "bracket_uid":"a", "home_prereq":"A2", "away_prereq":"A5"},
    {"round":1, "bracket_uid":"b", "home_prereq":"A4", "away_prereq":"A3"},

    {"round":2, "bracket_uid":"2", "home_prereq":"Wa", "away_prereq":"Wb"},
    {"round":2, "bracket_uid":"4", "home_prereq":"La", "away_prereq":"Lb"}
  ],
  "places": [
    {"position":1, "prereq": "A1"},
    {"position":2, "prereq": "W2"},
    {"position":3, "prereq": "L2"},
    {"position":4, "prereq": "W4"},
    {"position":5, "prereq": "L4"}
  ]
}


end

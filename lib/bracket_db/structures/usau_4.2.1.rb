BracketDb.define 'USAU_4.2.1' do
  name 'One team advances (USAU 4.2.1)'
  teams '4'
  days '2'


{
  "games": [
    pool '4.1''A', [1,2,3,4]

    {"round":1, "bracket_uid":"a", "home_prereq":"A1", "away_prereq":"A4"},
    {"round":1, "bracket_uid":"b", "home_prereq":"A2", "away_prereq":"A3"},

    {"round":2, "bracket_uid":"1", "home_prereq":"Wa", "away_prereq":"Wb"},
    {"round":2, "bracket_uid":"3", "home_prereq":"La", "away_prereq":"Lb"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "W3"},
    {"position":4, "prereq": "L3"}
  ]
}


end

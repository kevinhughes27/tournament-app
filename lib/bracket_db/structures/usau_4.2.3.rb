BracketDb.define 'USAU_4.2.3' do
  name 'Three teams advance (USAU 4.2.3)'
  description 'The last game for second place can be left unplayed since both teams have qualified already.
'
  teams '4'
  days '2'


{
  "games": [
    pool '4.1''A', [1,2,3,4]

    {"round":1, "bracket_uid":"a", "home_prereq":"A1", "away_prereq":"A4"},
    {"round":1, "bracket_uid":"b", "home_prereq":"A2", "away_prereq":"A3"},

    {"round":2, "bracket_uid":"1", "home_prereq":"Wa", "away_prereq":"Wb"},
    {"round":2, "bracket_uid":"d", "home_prereq":"La", "away_prereq":"Lb"},

    {"round":3, "bracket_uid":"2", "home_prereq":"Wd", "away_prereq":"L1"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "W2"},
    {"position":3, "prereq": "L2"},
    {"position":4, "prereq": "Ld"}
  ]
}


end

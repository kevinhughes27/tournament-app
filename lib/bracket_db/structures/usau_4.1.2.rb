BracketDb.define 'USAU_4.1.2' do
  name 'Two teams advance (USAU 4.1.2)'
  teams '4'
  days '1'


{
  "games": [
    {"round":1, "seed_round":1, "bracket_uid":"a", "home_prereq":"1", "away_prereq":"4"},
    {"round":1, "seed_round":1, "bracket_uid":"b", "home_prereq":"2", "away_prereq":"3"},

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

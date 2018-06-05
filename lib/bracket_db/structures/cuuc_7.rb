BracketDb.define 'CUUC_7' do
  name 'CUUC Women's Qualifier'
  teams '7'
  days '1'


{
  "games": [
    pool '3.1''O', [1,4,5]
    pool '4.1''P', [2,3,6,7]

    {"round":1, "bracket_uid":"zz", "home_prereq":"O1", "away_prereq":"P1"},
    {"round":1, "bracket_uid":"xx", "home_prereq":"O2", "away_prereq":"P4"},
    {"round":1, "bracket_uid":"yy", "home_prereq":"O3", "away_prereq":"P3"},
  ],
  "places": [
    {"position":1, "prereq": "Wzz"},
    {"position":2, "prereq": "Lzz"},
    {"position":3, "prereq": "P2"},
    {"position":4, "prereq": "Wxx"},
    {"position":5, "prereq": "Wyy"},
    {"position":6, "prereq": "Lxx"},
    {"position":7, "prereq": "Lyy"},
  ]
}


end

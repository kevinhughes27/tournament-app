BracketDb.define 'USAU_8.3' do
  name 'Three, Seven, or Eight teams advance (USAU 8.3)'
  description 'On the first day, play two pools of four and the first round of the bracket.
'
  teams '8'
  days '2'


{
  "games": [
    pool '4.1''A', [1,4,6,7]
    pool '4.1''B', [2,3,5,8]

    {"round": 1, "bracket_uid":"a", "home_prereq":"B2", "away_prereq":"A3"},
    {"round": 1, "bracket_uid":"b", "home_prereq":"A2", "away_prereq":"B3"},

    {"round": 2, "bracket_uid":"c", "home_prereq":"A1", "away_prereq":"Wa"},
    {"round": 2, "bracket_uid":"d", "home_prereq":"Wb", "away_prereq":"B1"},
    {"round": 3, "bracket_uid":"1", "home_prereq":"Wc", "away_prereq":"Wd"},

    {"round": 2, "bracket_uid":"f", "home_prereq":"B4", "away_prereq":"La"},
    {"round": 2, "bracket_uid":"g", "home_prereq":"Lb", "away_prereq":"A4"},

    {"round": 3, "bracket_uid":"h", "home_prereq":"Wf", "away_prereq":"Ld"},
    {"round": 3, "bracket_uid":"i", "home_prereq":"Wg", "away_prereq":"Lc"},
    {"round": 3, "bracket_uid":"7", "home_prereq":"Lf", "away_prereq":"Lg"},

    {"round": 4, "bracket_uid":"3", "home_prereq":"Wh", "away_prereq":"Wi"},
    {"round": 4, "bracket_uid":"5", "home_prereq":"Lh", "away_prereq":"Li"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "W3"},
    {"position":4, "prereq": "L3"},
    {"position":5, "prereq": "W5"},
    {"position":6, "prereq": "L5"},
    {"position":7, "prereq": "W7"},
    {"position":8, "prereq": "L7"}
  ]
}


end

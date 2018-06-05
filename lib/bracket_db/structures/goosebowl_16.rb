BracketDb.define 'GOOSEBOWL_16' do
  name 'Goosebowl'
  description 'Power Pools setup with only a single crossover
'
  teams '16'
  days '2'


{
  "games": [
    pool '4.1''A', [1,4,5,8]
    pool '4.1''B', [2,3,6,7]
    pool '4.1''C', [9,12,13,16]
    pool '4.1''D', [10,11,14,15]

    {"round":1, "bracket_uid":"xo1", "home_prereq":"A4", "away_prereq":"D1"},
    {"round":1, "bracket_uid":"xo2", "home_prereq":"B4", "away_prereq":"C1"},

    {"round": 2, "bracket_uid": "k", "home_prereq":"Lxo1", "away_prereq":"D4"},
    {"round": 2, "bracket_uid": "l", "home_prereq":"Lxo2", "away_prereq":"C4"},
    {"round": 2, "bracket_uid": "i", "home_prereq":"C2", "away_prereq":"D3"},
    {"round": 2, "bracket_uid": "j", "home_prereq":"D2", "away_prereq":"C3"},
    {"round": 2, "bracket_uid": "a", "home_prereq":"A1", "away_prereq":"Wxo2"},
    {"round": 2, "bracket_uid": "b", "home_prereq":"B1", "away_prereq":"Wxo1"},

    {"round": 3, "bracket_uid": "m", "home_prereq":"Wi", "away_prereq":"Wj"},
    {"round": 3, "bracket_uid": "15", "home_prereq":"Li", "away_prereq":"Lj"},
    {"round": 3, "bracket_uid": "n", "home_prereq":"Wk", "away_prereq":"Wl"},
    {"round": 3, "bracket_uid": "13", "home_prereq":"Lk", "away_prereq":"Ll"},
    {"round": 3, "bracket_uid": "c", "home_prereq":"A2", "away_prereq":"B3"},
    {"round": 3, "bracket_uid": "d", "home_prereq":"B2", "away_prereq":"A3"},

    {"round": 4, "bracket_uid": "9", "home_prereq":"Wm", "away_prereq":"Wn"},
    {"round": 4, "bracket_uid": "11", "home_prereq":"Lm", "away_prereq":"Ln"},
    {"round": 4, "bracket_uid": "e", "home_prereq":"Wa", "away_prereq":"Wd"},
    {"round": 4, "bracket_uid": "f", "home_prereq":"Wb", "away_prereq":"Wc"},

    {"round": 5, "bracket_uid": "5", "home_prereq":"La", "away_prereq":"Ld"},
    {"round": 5, "bracket_uid": "7", "home_prereq":"Lb", "away_prereq":"Lc"},
    {"round": 5, "bracket_uid": "1", "home_prereq":"We", "away_prereq":"Wf"},
    {"round": 5, "bracket_uid": "3", "home_prereq":"Le", "away_prereq":"Lf"}
  ],
  "places": [
    {"position":1, "prereq": "W1"},
    {"position":2, "prereq": "L1"},
    {"position":3, "prereq": "W3"},
    {"position":4, "prereq": "L3"},
    {"position":5, "prereq": "W5"},
    {"position":6, "prereq": "L5"},
    {"position":7, "prereq": "W7"},
    {"position":8, "prereq": "L7"},
    {"position":9, "prereq": "W9"},
    {"position":10, "prereq": "L9"},
    {"position":11, "prereq": "W11"},
    {"position":12, "prereq": "L11"},
    {"position":13, "prereq": "W13"},
    {"position":14, "prereq": "L13"},
    {"position":15, "prereq": "W15"},
    {"position":16, "prereq": "L15"}
  ]
}


end

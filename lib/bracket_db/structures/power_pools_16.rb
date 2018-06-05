BracketDb.define 'POWER_POOLS_16' do
  name 'Power Pools'
  teams '16'
  days '2'


{
  "games": [
    pool '4.1''A', [1,4,5,8]
    pool '4.1''B', [2,3,6,7]
    pool '4.1''C', [9,12,14,16]
    pool '4.1''D', [10,11,13,15]

    {"round":1, "bracket_uid":"xa", "home_prereq":"A3", "away_prereq":"C2"},
    {"round":1, "bracket_uid":"xb", "home_prereq":"B3", "away_prereq":"D2"},
    {"round":1, "bracket_uid":"xc", "home_prereq":"A4", "away_prereq":"C1"},
    {"round":1, "bracket_uid":"xd", "home_prereq":"B4", "away_prereq":"D1"},


    {"round": 2, "bracket_uid": "a", "home_prereq":"A1", "away_prereq":"Wxd"},
    {"round": 2, "bracket_uid": "b", "home_prereq":"B2", "away_prereq":"Wxa"},
    {"round": 2, "bracket_uid": "c", "home_prereq":"B1", "away_prereq":"Wxc"},
    {"round": 2, "bracket_uid": "d", "home_prereq":"A2", "away_prereq":"Wxb"},

    {"round": 3, "bracket_uid": "e", "home_prereq":"Wa", "away_prereq":"Wb"},
    {"round": 3, "bracket_uid": "f", "home_prereq":"Wc", "away_prereq":"Wd"},
    {"round": 3, "bracket_uid": "h", "home_prereq":"La", "away_prereq":"Lb"},
    {"round": 3, "bracket_uid": "i", "home_prereq":"Lc", "away_prereq":"Ld"},

    {"round": 4, "bracket_uid": "1", "home_prereq":"We", "away_prereq":"Wf"},
    {"round": 4, "bracket_uid": "3", "home_prereq":"Le", "away_prereq":"Lf"},
    {"round": 4, "bracket_uid": "5", "home_prereq":"Wh", "away_prereq":"Wi"},
    {"round": 4, "bracket_uid": "7", "home_prereq":"Lh", "away_prereq":"Li"},


    {"round": 2, "bracket_uid": "aa", "home_prereq":"Lxc", "away_prereq":"D4"},
    {"round": 2, "bracket_uid": "bb", "home_prereq":"Lxd", "away_prereq":"C4"},
    {"round": 2, "bracket_uid": "cc", "home_prereq":"Lxa", "away_prereq":"D3"},
    {"round": 2, "bracket_uid": "dd", "home_prereq":"Lxb", "away_prereq":"C3"},

    {"round": 3, "bracket_uid": "ee", "home_prereq":"Waa", "away_prereq":"Wdd"},
    {"round": 3, "bracket_uid": "ff", "home_prereq":"Wcc", "away_prereq":"Wbb"},
    {"round": 3, "bracket_uid": "hh", "home_prereq":"Laa", "away_prereq":"Ldd"},
    {"round": 3, "bracket_uid": "ii", "home_prereq":"Lcc", "away_prereq":"Lbb"},

    {"round": 4, "bracket_uid": "9", "home_prereq":"Wee", "away_prereq":"Wff"},
    {"round": 4, "bracket_uid": "11", "home_prereq":"Lee", "away_prereq":"Lff"},
    {"round": 4, "bracket_uid": "13", "home_prereq":"Whh", "away_prereq":"Wii"},
    {"round": 4, "bracket_uid": "15", "home_prereq":"Lhh", "away_prereq":"Lii"},
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

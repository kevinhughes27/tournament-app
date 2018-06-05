BracketDb.define 'USAU_24.1' do
  name 'One team advances (USAU 24.1)'
  teams '24'
  days '2'


{
  "games": [
    pool '6.1.2''A', [1,8,12,13,17,24]
    pool '6.1.2''B', [2,7,11,14,18,23]
    pool '6.1.2''C', [3,6,10,15,19,22]
    pool '6.1.2''D', [4,5,9,16,20,21]

    bracket '16.1'

    {"round": 1, "bracket_uid":"aa", "home_prereq":"A4", "away_prereq":"D5"},
    {"round": 1, "bracket_uid":"bb", "home_prereq":"B4", "away_prereq":"C5"},
    {"round": 1, "bracket_uid":"cc", "home_prereq":"A5", "away_prereq":"D4"},
    {"round": 1, "bracket_uid":"dd", "home_prereq":"B5", "away_prereq":"C4"},

    {"round": 2, "bracket_uid": "ee", "home_prereq":"Waa", "away_prereq":"Wbb"},
    {"round": 2, "bracket_uid": "ff", "home_prereq":"Wcc", "away_prereq":"Wdd"},
    {"round": 2, "bracket_uid": "hh", "home_prereq":"Laa", "away_prereq":"Lbb"},
    {"round": 2, "bracket_uid": "ii", "home_prereq":"Lcc", "away_prereq":"Ldd"},

    {"round": 3, "bracket_uid": "13", "home_prereq":"Wee", "away_prereq":"Wff"},
    {"round": 3, "bracket_uid": "15", "home_prereq":"Lee", "away_prereq":"Lff"},
    {"round": 3, "bracket_uid": "17", "home_prereq":"Whh", "away_prereq":"Wii"},
    {"round": 3, "bracket_uid": "19", "home_prereq":"Lhh", "away_prereq":"Lii"},

    {"round":1, "bracket_uid":"aaa", "home_prereq":"A6", "away_prereq":"D6"},
    {"round":1, "bracket_uid":"bbb", "home_prereq":"B6", "away_prereq":"C6"},

    {"round":2, "bracket_uid":"21", "home_prereq":"Waaa", "away_prereq":"Wbbb"},
    {"round":2, "bracket_uid":"23", "home_prereq":"Laaa", "away_prereq":"Lbbb"}
  ],
  "places": [
    <%= BracketDb::partial('places_16.1') %>
    {"position":13, "prereq": "W13"},
    {"position":14, "prereq": "L13"},
    {"position":15, "prereq": "W15"},
    {"position":16, "prereq": "L15"},
    {"position":17, "prereq": "W17"},
    {"position":18, "prereq": "L17"},
    {"position":19, "prereq": "W19"},
    {"position":20, "prereq": "L19"},
    {"position":21, "prereq": "W21"},
    {"position":22, "prereq": "L21"},
    {"position":23, "prereq": "W23"},
    {"position":24, "prereq": "L23"}
  ]
}


end

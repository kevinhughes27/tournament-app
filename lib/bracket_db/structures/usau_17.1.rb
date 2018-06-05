BracketDb.define 'USAU_17.1' do
  name 'One team advances (USAU 17.1)'
  teams '17'
  days '2'


{
  "games": [
    pool '5.1.2''A', [1,8,12,13,17]
    pool '4.1''B', [2,7,11,14]
    pool '4.1''C', [3,6,10,15]
    pool '4.1''D', [4,5,9,16]

    bracket '16.1'

    <% 'usau_5.3' %>
    {"round":1, "bracket_uid":"aa", "home_prereq":"B4", "away_prereq":"C4"},
    {"round":2, "bracket_uid":"13", "home_prereq":"A4", "away_prereq":"Waa"},

    {"round":1, "bracket_uid":"cc", "home_prereq":"D4", "away_prereq":"A5"},
    {"round":2, "bracket_uid":"15", "home_prereq":"Wcc", "away_prereq":"Laa"}
  ],
  "places": [
    <%= BracketDb::partial('places_16.1') %>
    {"position":13, "prereq": "W13"},
    {"position":14, "prereq": "L13"},
    {"position":15, "prereq": "W15"},
    {"position":16, "prereq": "L15"},
    {"position":17, "prereq": "Lcc"}
  ]
}


end

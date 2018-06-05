BracketDb.define 'USAU_15.1' do
  name 'One team advances (USAU 15.1)'
  description 'Bottom 3 teams play a round robin on the second day
'
  teams '15'
  days '2'


{
  "games": [
    pool '3.1''A', [1,8,9]
    pool '4.1''B', [2,7,10,15]
    pool '4.1''C', [3,6,11,14]
    pool '4.1''D', [4,5,12,13]

    bracket '16.1'

    {"round": 1, "bracket_uid": "aa", "home_prereq":"B4", "away_prereq":"D4"},
    {"round": 2, "bracket_uid": "bb", "home_prereq":"C4", "away_prereq":"D4"},
    {"round": 3, "bracket_uid": "cc", "home_prereq":"B4", "away_prereq":"C4"}
  ],
  "places": [
    <%= BracketDb::partial('places_16.1') %>
    {"position":13, "prereq": "B4"},
    {"position":14, "prereq": "C4"},
    {"position":15, "prereq": "D4"}
  ]
}


end

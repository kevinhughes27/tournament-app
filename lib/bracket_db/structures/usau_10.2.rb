BracketDb.define 'USAU_10.2' do
  name 'Two teams advance (USAU 10.2)'
  teams '10'
  days '2'


{
  "games": [
    pool '5.1.1''A', [1,3,6,8,9]
    pool '5.1.3''B', [2,4,5,7,10]

    bracket '8.2.1'
    {"round":1, "bracket_uid":"9", "home_prereq":"A5", "away_prereq":"B5"}
  ],
  "places": [
    <%= BracketDb::partial('places_8.2.1'
    {"position":9, "prereq": "W9"},
    {"position":10, "prereq": "L9"}
  ]
}


end

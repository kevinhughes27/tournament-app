BracketDb.define 'USAU 11.1' do
  name 'One team advances (USAU 11.1)'
  description 'Bottom 3 teams play a round robin on the second day.'
  teams 11
  days 2

  pool '5.1.1', 'A', [1,3,6,8,9]
  pool '6.1.2', 'B', [2,4,5,7,10,11]

  bracket '8.1'

  games [
    {round: 1, bracket_uid: "aa", home_prereq: "A5", away_prereq: "B6"},
    {round: 2, bracket_uid: "bb", home_prereq: "B5", away_prereq: "B6"},
    {round: 3, bracket_uid: "cc", home_prereq: "A5", away_prereq: "B5"}
  ]

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 A5 B5 B6)
end

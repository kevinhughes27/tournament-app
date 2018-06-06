BracketDb.define 'USAU 15.1' do
  name 'One team advances (USAU 15.1)'
  description 'Bottom 3 teams play a round robin on the second day'
  teams 15
  days 2

  pool '3.1', 'A', [1,8,9]
  pool '4.1', 'B', [2,7,10,15]
  pool '4.1', 'C', [3,6,11,14]
  pool '4.1', 'D', [4,5,12,13]

  bracket '16.1'

  games [
    {round: 1, bracket_uid: "aa", home_prereq: "B4", away_prereq: "D4"},
    {round: 2, bracket_uid: "bb", home_prereq: "C4", away_prereq: "D4"},
    {round: 3, bracket_uid: "cc", home_prereq: "B4", away_prereq: "C4"}
  ]

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9 W11 L11)
  places %w(B4 C4 D4)
end

BracketDb.define 'USAU 12.1' do
  name 'One team advances (USAU 12.1)'
  teams 12
  days 2

  pool '6.1.2', 'A', [1,3,6,7,10,12]
  pool '6.1.2', 'B', [2,4,5,8,9,11]

  bracket '8.1'

  games [
    {round:1, bracket_uid: "aa", home_prereq: "A5", away_prereq: "B6"},
    {round:1, bracket_uid: "bb", home_prereq: "A6", away_prereq: "B5"},

    {round:2, bracket_uid: "9", home_prereq: "Waa", away_prereq: "Wbb"},
    {round:2, bracket_uid: "11", home_prereq: "Laa", away_prereq: "Lbb"}
  ]

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9 W11 L11)
end

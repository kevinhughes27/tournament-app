BracketDb.define 'USAU 19.1' do
  name 'One team advances (USAU 19.1)'
  teams 19
  days 2

  pool '5.1.2', 'A', [1,8,12,13,17]
  pool '5.1.2', 'B', [2,7,11,14,18]
  pool '5.1.2', 'C', [3,6,10,15,19]
  pool '4.1', 'D', [4,5,9,16]

  bracket '16.1'

  games [
    {round: 1, bracket_uid: "aa", home_prereq: "B4", away_prereq: "D4"},
    {round: 1, bracket_uid: "bb", home_prereq: "A5", away_prereq: "C4"},
    {round: 1, bracket_uid: "cc", home_prereq: "B5", away_prereq: "C5"},

    {round: 2, bracket_uid: "dd", home_prereq: "A4", away_prereq: "Waa"},
    {round: 2, bracket_uid: "ee", home_prereq: "Wbb", away_prereq: "Wcc"},
    {round: 2, bracket_uid: "ff", home_prereq: "Laa", away_prereq: "Lcc"},

    {round: 3, bracket_uid: "13", home_prereq: "Wee", away_prereq: "Wdd"},
    {round: 3, bracket_uid: "15", home_prereq: "Lee", away_prereq: "Ldd"},
    {round: 3, bracket_uid: "17", home_prereq: "Wff", away_prereq: "Lbb"}
  ]

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9 W11 L11)
  places %w(W13 L13 W15 L15 W17 L17 Lff)
end

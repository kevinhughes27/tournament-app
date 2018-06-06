BracketDb.define 'USAU 9.1' do
  name 'One team advances (USAU 9.1)'
  description 'The pool of five plays games to 11, while the pool of four plays games to 15 in order to balance the total number of points played between pools.'
  teams 9
  days 2

  pool '5.1.3', 'A', [1,3,6,8,9]
  pool '4.1', 'B', [2,4,5,7]

  games [
    {round: 1, bracket_uid: "a", home_prereq: "A1", away_prereq: "B4"},
    {round: 1, bracket_uid: "b", home_prereq: "B2", away_prereq: "A3"},
    {round: 1, bracket_uid: "c", home_prereq: "A2", away_prereq: "B3"},
    {round: 1, bracket_uid: "d", home_prereq: "B1", away_prereq: "A4"},

    {round: 2, bracket_uid: "e", home_prereq: "Wa", away_prereq: "Wb"},
    {round: 2, bracket_uid: "f", home_prereq: "Wc", away_prereq: "Wd"},
    {round: 2, bracket_uid: "h", home_prereq: "La", away_prereq: "Lb"},
    {round: 2, bracket_uid: "i", home_prereq: "Lc", away_prereq: "Ld"},

    {round: 3, bracket_uid: "1", home_prereq: "We", away_prereq: "Wf"},
    {round: 3, bracket_uid: "3", home_prereq: "Le", away_prereq: "Lf"},
    {round: 3, bracket_uid: "5", home_prereq: "Wh", away_prereq: "Wi"},
    {round: 3, bracket_uid: "7", home_prereq: "Lh", away_prereq: "Li"}
  ]

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 A5)
end

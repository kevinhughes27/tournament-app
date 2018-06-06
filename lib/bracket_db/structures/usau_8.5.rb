BracketDb.define 'USAU 8.5' do
  name 'Five teams advance (USAU 8.5)'
  teams 8
  days 2

  pool '4.1', 'A', [1,3,6,8]
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

    {round: 3, bracket_uid: "j", home_prereq: "Wh", away_prereq: "Lf"},
    {round: 3, bracket_uid: "k", home_prereq: "Wi", away_prereq: "Le"},
    {round: 3, bracket_uid: "7", home_prereq: "Lh", away_prereq: "Li"},

    {round: 4, bracket_uid: "l", home_prereq: "Wj", away_prereq: "Wk"},
    {round: 4, bracket_uid: "5", home_prereq: "Lj", away_prereq: "Lk"},

    {round: 5, bracket_uid: "2", home_prereq: "Wl", away_prereq: "L1"}
  ]

  places %w(W1 W2 L2 Ll W5 L5 W7 L7)
end

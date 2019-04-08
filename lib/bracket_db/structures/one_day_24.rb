BracketDb.define 'One Day 24' do
  name 'One Day 24'
  teams 24
  days 1

  pool '4.1', 'A', %w(1 2 3 4)

  pool '4.1', 'B', %w(5 9  13 17)
  pool '4.1', 'C', %w(6 10 14 18)
  pool '4.1', 'D', %w(7 11 15 19)
  pool '4.1', 'E', %w(8 12 16 20)

  pool '4.1', 'F', %w(21 22 23 24)

  games [
    # P
    {round: 1, bracket_uid: "a", home_prereq: "A1", away_prereq: "A4"},
    {round: 1, bracket_uid: "b", home_prereq: "A2", away_prereq: "A3"},
    {round: 2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"},
    {round: 2, bracket_uid: "3", home_prereq: "La", away_prereq: "Lb"},

    # L
    {round: 1, bracket_uid: "c", home_prereq: "B1", away_prereq: "E1"},
    {round: 1, bracket_uid: "d", home_prereq: "C1", away_prereq: "D1"},
    {round: 2, bracket_uid: "5", home_prereq: "Wc", away_prereq: "Wd"},
    {round: 2, bracket_uid: "7", home_prereq: "Lc", away_prereq: "Ld"},

    # M
    {round: 1, bracket_uid: "e", home_prereq: "B2", away_prereq: "E2"},
    {round: 1, bracket_uid: "f", home_prereq: "C2", away_prereq: "D2"},
    {round: 2, bracket_uid: "9", home_prereq: "We", away_prereq: "Wf"},
    {round: 2, bracket_uid: "11", home_prereq: "Le", away_prereq: "Lf"},

    # N
    {round: 1, bracket_uid: "g", home_prereq: "B3", away_prereq: "E3"},
    {round: 1, bracket_uid: "h", home_prereq: "C3", away_prereq: "D3"},
    {round: 2, bracket_uid: "13", home_prereq: "Wg", away_prereq: "Wh"},
    {round: 2, bracket_uid: "15", home_prereq: "Lg", away_prereq: "Lh"},

    # O
    {round: 1, bracket_uid: "i", home_prereq: "B4", away_prereq: "E4"},
    {round: 1, bracket_uid: "j", home_prereq: "C4", away_prereq: "D4"},
    {round: 2, bracket_uid: "17", home_prereq: "Wi", away_prereq: "Wj"},
    {round: 2, bracket_uid: "19", home_prereq: "Li", away_prereq: "Lj"},

    # R
    {round: 1, bracket_uid: "k", home_prereq: "F1", away_prereq: "F4"},
    {round: 1, bracket_uid: "l", home_prereq: "F2", away_prereq: "F3"},
    {round: 2, bracket_uid: "21", home_prereq: "Wk", away_prereq: "Wl"},
    {round: 2, bracket_uid: "23", home_prereq: "Lk", away_prereq: "Ll"}
  ]

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9 W11 L11)
  places %w(W13 L13 W15 L15 W17 L17 W19 L19 W21 L21 W23 L23)
end

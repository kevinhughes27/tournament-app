BracketDb.define 'USAU_8.6' do
  name 'Six teams advance (USAU 8.6)'
  teams 8
  days 2

  pool '4.1', 'A', [1,4,6,7]
  pool '4.1', 'B', [2,3,5,8]

  games do
    [
      {round: 1, bracket_uid: "a", home_prereq: "B2", away_prereq: "A3"},
      {round: 1, bracket_uid: "b", home_prereq: "A2", away_prereq: "B3"},

      {round: 2, bracket_uid: "c", home_prereq: "A1", away_prereq: "Wa"},
      {round: 2, bracket_uid: "d", home_prereq: "Wb", away_prereq: "B1"},

      {round: 2, bracket_uid: "h", home_prereq: "La", away_prereq: "B4"},
      {round: 2, bracket_uid: "i", home_prereq: "A4", away_prereq: "Lb"},

      {round: 3, bracket_uid: "1", home_prereq: "Wc", away_prereq: "Wd"},
      {round: 3, bracket_uid: "f", home_prereq: "Lc", away_prereq: "Ld"},
      {round: 3, bracket_uid: "j", home_prereq: "Wh", away_prereq: "Wi"},
      {round: 3, bracket_uid: "l", home_prereq: "Lh", away_prereq: "Li"},

      {round: 4, bracket_uid: "2", home_prereq: "L1", away_prereq: "Wf"},
      {round: 4, bracket_uid: "4", home_prereq: "Lf", away_prereq: "Wj"},
      {round: 4, bracket_uid: "6", home_prereq: "Lj", away_prereq: "Wl"}
    ]
  end

  places %w(W1 W2 L2 W4 L4 W6 L6 Ll)
end

BracketDb.define 'USAU 10.5' do
  name 'Six teams advance (USAU 10.5)'
  teams 10
  days 2

  pool '5.1.4', 'A', [1,3,6,7,10]
  pool '5.1.4', 'B', [2,4,5,8,9]

  games [
    # bracket 4.2.2
    {round:1, bracket_uid: "a", home_prereq: "A1", away_prereq: "B2"},
    {round:1, bracket_uid: "b", home_prereq: "B1", away_prereq: "A2"},

    {round:2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"},
    {round:2, bracket_uid: "d", home_prereq: "La", away_prereq: "Lb"},

    {round:3, bracket_uid: "2", home_prereq: "L1", away_prereq: "Wd"},

    # bracket 6.2
    {round:1, bracket_uid: "h", home_prereq: "A4", away_prereq: "B5"},
    {round:1, bracket_uid: "i", home_prereq: "B4", away_prereq: "A5"},

    {round:2, bracket_uid: "f", home_prereq: "A3", away_prereq: "B3"},
    {round:2, bracket_uid: "j", home_prereq: "Wh", away_prereq: "Wi"},

    {round:3, bracket_uid: "g", home_prereq: "Ld", away_prereq: "Wf"},
    {round:3, bracket_uid: "k", home_prereq: "Lf", away_prereq: "Wj"},
    {round:3, bracket_uid: "l", home_prereq: "Lh", away_prereq: "Li"}
  ]

  places %w(W1 W2 L2 Wg Lg Wk Lk Lj Wl Ll)
end

BracketDb.define 'USAU 13.1' do
  name 'One team advances (USAU 13.1)'
  teams 13
  days 2

  pool '5.1.2', 'A', [1,6,7,12,13]
  pool '4.1', 'B', [2,5,8,11]
  pool '4.1', 'C', [3,4,9,10]

  games [
    {round:1, bracket_uid: "a", home_prereq: "B3", away_prereq: "C3"},
    {round:1, bracket_uid: "10", home_prereq: "B4", away_prereq: "C4"},
    {round:1, bracket_uid: "12", home_prereq: "A4", away_prereq: "A5"},

    {round:2, bracket_uid: "b", home_prereq: "A1", away_prereq: "Wa"},
    {round:2, bracket_uid: "c", home_prereq: "C2", away_prereq: "B2"},
    {round:2, bracket_uid: "d", home_prereq: "C1", away_prereq: "A2"},
    {round:2, bracket_uid: "e", home_prereq: "B1", away_prereq: "A3"},

    {round:3, bracket_uid: "f", home_prereq: "Wb", away_prereq: "Wc"},
    {round:3, bracket_uid: "g", home_prereq: "Wd", away_prereq: "We"},
    {round:3, bracket_uid: "i", home_prereq: "Lb", away_prereq: "Ld"},
    {round:3, bracket_uid: "j", home_prereq: "Lc", away_prereq: "Le"},

    {round:4, bracket_uid: "1", home_prereq: "Wf", away_prereq: "Wg"},
    {round:4, bracket_uid: "k", home_prereq: "Wi", away_prereq: "Lf"},
    {round:4, bracket_uid: "l", home_prereq: "Wj", away_prereq: "Lg"},
    {round:4, bracket_uid: "7", home_prereq: "Li", away_prereq: "Lj"},

    {round:5, bracket_uid: "3", home_prereq: "Wk", away_prereq: "Wl"},
    {round:5, bracket_uid: "5", home_prereq: "Lk", away_prereq: "Ll"}
  ]

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 La W10 L10 W12 L12)
end

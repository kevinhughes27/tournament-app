BracketDb.define 'Goosebowl 8 (rec)' do
  name 'Goosebowl 2019 Rec'
  description 'The first day has two pools of four and the second day is a shortened bracket.'
  teams 8
  days 2

  pool '4.1', 'C', %w(1 3 6 8)
  pool '4.1', 'D', %w(2 4 5 7)

  games [
    {round: 1, bracket_uid: "k", home_prereq: "C1", away_prereq: "D4"},
    {round: 1, bracket_uid: "l", home_prereq: "D1", away_prereq: "C4"},
    {round: 1, bracket_uid: "i", home_prereq: "C2", away_prereq: "D3"},
    {round: 1, bracket_uid: "j", home_prereq: "D2", away_prereq: "C3"},

    {round: 2, bracket_uid: "n", home_prereq: "Wk", away_prereq: "Wl"},
    {round: 2, bracket_uid: "p", home_prereq: "Lk", away_prereq: "Ll"},
    {round: 2, bracket_uid: "m", home_prereq: "Wi", away_prereq: "Wj"},
    {round: 2, bracket_uid: "o", home_prereq: "Li", away_prereq: "Lj"}
  ]

  places %w(Wn Ln Wm Lm Wp Lp Wo Lo)
end

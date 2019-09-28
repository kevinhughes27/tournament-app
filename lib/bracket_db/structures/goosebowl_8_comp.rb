BracketDb.define 'Goosebowl 8 (comp)' do
  name 'Goosebowl 2019 Comp'
  description 'The first day has two pools of four and the second day is a shortened bracket.'
  teams 8
  days 2

  pool '4.1', 'A', %w(1 3 6 8)
  pool '4.1', 'B', %w(2 4 5 7)

  games [
    {round: 1, bracket_uid: "a", home_prereq: "A1", away_prereq: "B4"},
    {round: 1, bracket_uid: "b", home_prereq: "B1", away_prereq: "A4"},

    {round: 2, bracket_uid: "c", home_prereq: "A2", away_prereq: "B3"},
    {round: 2, bracket_uid: "d", home_prereq: "B2", away_prereq: "A3"},

    {round: 3, bracket_uid: "e", home_prereq: "Wa", away_prereq: "Wd"},
    {round: 3, bracket_uid: "f", home_prereq: "Wb", away_prereq: "Wc"},
    {round: 3, bracket_uid: "s", home_prereq: "La", away_prereq: "Ld"},
    {round: 3, bracket_uid: "t", home_prereq: "Lc", away_prereq: "Lb"},

    {round: 4, bracket_uid: "g", home_prereq: "We", away_prereq: "Wf"},
    {round: 4, bracket_uid: "h", home_prereq: "Le", away_prereq: "Lf"},
    {round: 4, bracket_uid: "u", home_prereq: "Ws", away_prereq: "Wt"},
    {round: 4, bracket_uid: "v", home_prereq: "Ls", away_prereq: "Lt"}
  ]

  places %w(Wg Lg Wh Lh Wu Lu Wv Lv)
end

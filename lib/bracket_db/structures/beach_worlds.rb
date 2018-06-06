BracketDb.define 'Beach Worlds' do
  name 'Beach Worlds'
  teams 12
  days 5

  pool 'beach_12', 'P', [1,2,3,4,5,6,7,8,9,10,11,12]

  games [
    {round:1, bracket_uid: "a1", home_prereq: "P1", away_prereq: "P4"},
    {round:1, bracket_uid: "a2", home_prereq: "P2", away_prereq: "P3"},

    {round:1, bracket_uid: "b1", home_prereq: "P5", away_prereq: "P8"},
    {round:1, bracket_uid: "b2", home_prereq: "P6", away_prereq: "P7"},

    {round:1, bracket_uid: "c1", home_prereq: "P9", away_prereq: "P12"},
    {round:1, bracket_uid: "c2", home_prereq: "P10", away_prereq: "P11"},

    {round:2, bracket_uid: "a3", home_prereq: "La1", away_prereq: "La2"},
    {round:2, bracket_uid: "b3", home_prereq: "Lb1", away_prereq: "Lb2"},
    {round:2, bracket_uid: "c3", home_prereq: "Lc1", away_prereq: "Lc2"},

    {round:3, bracket_uid: "b4", home_prereq: "Wb1", away_prereq: "Wb2"},
    {round:3, bracket_uid: "c4", home_prereq: "Wc1", away_prereq: "Wc2"},

    {round:4, bracket_uid: "a4", home_prereq: "Wa1", away_prereq: "Wa2"}
  ]

  places %w(Wa4 La4 Wa3 La3 Wb4 Lb4 Wb3 Lb3 Wc4 Lc4 Wc3 Lc3)
end

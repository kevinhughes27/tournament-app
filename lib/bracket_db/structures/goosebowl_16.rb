BracketDb.define 'GOOSEBOWL_16' do
  name 'Goosebowl'
  description 'Power Pools setup with only a single crossover'
  teams 16
  days 2

  pool '4.1', 'A', [1,4,5,8]
  pool '4.1', 'B', [2,3,6,7]
  pool '4.1', 'C', [9,12,13,16]
  pool '4.1', 'D', [10,11,14,15]

  games do
    [
      {round:1, bracket_uid: "xo1", home_prereq: "A4", away_prereq: "D1"},
      {round:1, bracket_uid: "xo2", home_prereq: "B4", away_prereq: "C1"},

      {round: 2, bracket_uid: "k", home_prereq: "Lxo1", away_prereq: "D4"},
      {round: 2, bracket_uid: "l", home_prereq: "Lxo2", away_prereq: "C4"},
      {round: 2, bracket_uid: "i", home_prereq: "C2", away_prereq: "D3"},
      {round: 2, bracket_uid: "j", home_prereq: "D2", away_prereq: "C3"},
      {round: 2, bracket_uid: "a", home_prereq: "A1", away_prereq: "Wxo2"},
      {round: 2, bracket_uid: "b", home_prereq: "B1", away_prereq: "Wxo1"},

      {round: 3, bracket_uid: "m", home_prereq: "Wi", away_prereq: "Wj"},
      {round: 3, bracket_uid: "15", home_prereq: "Li", away_prereq: "Lj"},
      {round: 3, bracket_uid: "n", home_prereq: "Wk", away_prereq: "Wl"},
      {round: 3, bracket_uid: "13", home_prereq: "Lk", away_prereq: "Ll"},
      {round: 3, bracket_uid: "c", home_prereq: "A2", away_prereq: "B3"},
      {round: 3, bracket_uid: "d", home_prereq: "B2", away_prereq: "A3"},

      {round: 4, bracket_uid: "9", home_prereq: "Wm", away_prereq: "Wn"},
      {round: 4, bracket_uid: "11", home_prereq: "Lm", away_prereq: "Ln"},
      {round: 4, bracket_uid: "e", home_prereq: "Wa", away_prereq: "Wd"},
      {round: 4, bracket_uid: "f", home_prereq: "Wb", away_prereq: "Wc"},

      {round: 5, bracket_uid: "5", home_prereq: "La", away_prereq: "Ld"},
      {round: 5, bracket_uid: "7", home_prereq: "Lb", away_prereq: "Lc"},
      {round: 5, bracket_uid: "1", home_prereq: "We", away_prereq: "Wf"},
      {round: 5, bracket_uid: "3", home_prereq: "Le", away_prereq: "Lf"}
    ]
  end

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9 W11 L11 W13 L13 W15 L15)
end

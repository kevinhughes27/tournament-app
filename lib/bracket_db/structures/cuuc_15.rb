BracketDb.define 'CUUC_15' do
  name 'CUUC Friday Open Division'
  teams 15
  days 1

  games do
    [
      {round: 1, seed_round: 1, bracket_uid: "b", home_prereq: 8, away_prereq: 9},
      {round: 1, seed_round: 1, bracket_uid: "c", home_prereq: 4, away_prereq: 13},
      {round: 1, seed_round: 1, bracket_uid: "d", home_prereq: 5, away_prereq: 12},
      {round: 1, seed_round: 1, bracket_uid: "e", home_prereq: 2, away_prereq: 15},
      {round: 1, seed_round: 1, bracket_uid: "f", home_prereq: 7, away_prereq: 10},
      {round: 1, seed_round: 1, bracket_uid: "g", home_prereq: 3, away_prereq: 14},
      {round: 1, seed_round: 1, bracket_uid: "h", home_prereq: 6, away_prereq: 11},

      {round: 2, seed_round: 1, bracket_uid: "i", home_prereq: 1, away_prereq: "Wb"},
      {round: 2, bracket_uid: "j", home_prereq: "Wc", away_prereq: "Wd"},
      {round: 2, bracket_uid: "k", home_prereq: "We", away_prereq: "Wf"},
      {round: 2, bracket_uid: "l", home_prereq: "Wg", away_prereq: "Wh"},

      {round: 2, bracket_uid: "o", home_prereq: "Lh", away_prereq: "Lg"},
      {round: 2, bracket_uid: "p", home_prereq: "Lf", away_prereq: "Le"},
      {round: 2, bracket_uid: "q", home_prereq: "Lc", away_prereq: "Ld"},

      {round: 3, bracket_uid: "s", home_prereq: "Lj", away_prereq: "Wo"},
      {round: 3, bracket_uid: "t", home_prereq: "Li", away_prereq: "Wp"},
      {round: 3, bracket_uid: "u", home_prereq: "Ll", away_prereq: "Wq"},
      {round: 3, bracket_uid: "v", home_prereq: "Lk", away_prereq: "Lb"},
      {round: 3, bracket_uid: "aa", home_prereq: "Lo", away_prereq: "Lp"},

      {round: 4, bracket_uid: "m", home_prereq: "Wi", away_prereq: "Wj"},
      {round: 4, bracket_uid: "n", home_prereq: "Wk", away_prereq: "Wl"},
      {round: 4, bracket_uid: "w", home_prereq: "Ws", away_prereq: "Wt"},
      {round: 4, bracket_uid: "x", home_prereq: "Wu", away_prereq: "Wv"},

      {round: 5, bracket_uid: "y", home_prereq: "Ln", away_prereq: "Ww"},
      {round: 5, bracket_uid: "z", home_prereq: "Lm", away_prereq: "Wx"},
    ]
  end

  places %w(Wm Wn Wy Wz Ly Lz Lw Lx Lv Lt Ls Lu Lq Laa)
end

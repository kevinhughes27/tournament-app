BracketDb.define 'CUUC 23' do
  name 'CUUC Open Div II'
  teams 23
  days 2

  games do
    [
      {round: 1, seed_round: 1, bracket_uid: "a", home_prereq: 16, away_prereq: 17},
      {round: 1, seed_round: 1, bracket_uid: "b", home_prereq: 14, away_prereq: 19},
      {round: 1, seed_round: 1, bracket_uid: "c", home_prereq: 11, away_prereq: 22},
      {round: 1, seed_round: 1, bracket_uid: "d", home_prereq: 15, away_prereq: 18},
      {round: 1, seed_round: 1, bracket_uid: "e", home_prereq: 10, away_prereq: 23},
      {round: 1, seed_round: 1, bracket_uid: "f", home_prereq: 13, away_prereq: 20},
      {round: 1, seed_round: 1, bracket_uid: "g", home_prereq: 12, away_prereq: 21},

      {round: 2, seed_round: 1, bracket_uid: "h", home_prereq: 1, away_prereq: "Wa"},
      {round: 2, seed_round: 1, bracket_uid: "i", home_prereq: 7, away_prereq: 9},
      {round: 2, seed_round: 1, bracket_uid: "j", home_prereq: 3, away_prereq: "Wb"},
      {round: 2, seed_round: 1, bracket_uid: "k", home_prereq: 5, away_prereq: "Wc"},
      {round: 2, seed_round: 1, bracket_uid: "l", home_prereq: 2, away_prereq: "Wd"},
      {round: 2, seed_round: 1, bracket_uid: "m", home_prereq: 8, away_prereq: "We"},
      {round: 2, seed_round: 1, bracket_uid: "n", home_prereq: 4, away_prereq: "Wf"},
      {round: 2, seed_round: 1, bracket_uid: "o", home_prereq: 6, away_prereq: "Wg"},

      {round: 3, bracket_uid: "pp", home_prereq: "Ld", away_prereq: "Le"},
      {round: 3, bracket_uid: "qq", home_prereq: "Lf", away_prereq: "Lg"},
    ]
  end

  pool '3.1', 'E', ["La","Lb","Lc"]

  games do
    [
      {round: 4, bracket_uid: "r", home_prereq: "Wl", away_prereq: "Wm"},
      {round: 4, bracket_uid: "s", home_prereq: "Wn", away_prereq: "Wo"},
      {round: 4, bracket_uid: "v", home_prereq: "Lh", away_prereq: "Li"},
      {round: 4, bracket_uid: "y", home_prereq: "Lj", away_prereq: "Lk"},

      {round: 5, bracket_uid: "p", home_prereq: "Wh", away_prereq: "Wi"},
      {round: 5, bracket_uid: "q", home_prereq: "Wj", away_prereq: "Wk"},
      {round: 5, bracket_uid: "u", home_prereq: "Wr", away_prereq: "Ws"},
      {round: 5, bracket_uid: "z", home_prereq: "Lr", away_prereq: "Wv"},
      {round: 5, bracket_uid: "cc", home_prereq: "Ls", away_prereq: "Wy"},
      {round: 5, bracket_uid: "w", home_prereq: "Ln", away_prereq: "Lo"},
      {round: 5, bracket_uid: "x", home_prereq: "Ll", away_prereq: "Lm"},
      {round: 5, bracket_uid: "rr", home_prereq: "Wpp", away_prereq: "Wqq"},
      {round: 5, bracket_uid: "ss", home_prereq: "Lpp", away_prereq: "Lqq"},

      {round: 6, bracket_uid: "t", home_prereq: "Wp", away_prereq: "Wq"},
      {round: 6, bracket_uid: "aa", home_prereq: "Lq", away_prereq: "Ww"},
      {round: 6, bracket_uid: "bb", home_prereq: "Lp", away_prereq: "Wx"},

      {round: 7, bracket_uid: "dd", home_prereq: "Wt", away_prereq: "Wz"},
      {round: 7, bracket_uid: "ee", home_prereq: "Lu", away_prereq: "Waa"},
      {round: 7, bracket_uid: "ff", home_prereq: "Wu", away_prereq: "Wbb"},
      {round: 7, bracket_uid: "gg", home_prereq: "Lt", away_prereq: "Wcc"},

      {round: 8, bracket_uid: "ll", home_prereq: "Ldd", away_prereq: "Lee"},
      {round: 8, bracket_uid: "mm", home_prereq: "Lff", away_prereq: "Lgg"},

      {round: 9, bracket_uid: "hh", home_prereq: "Wdd", away_prereq: "Wee"},
      {round: 9, bracket_uid: "ii", home_prereq: "Wff", away_prereq: "Wgg"},

      {round: 10, bracket_uid: "kk", home_prereq: "Lhh", away_prereq: "Lii"},
      {round: 10, bracket_uid: "nn", home_prereq: "Wll", away_prereq: "Wmm"},
      {round: 10, bracket_uid: "oo", home_prereq: "Lll", away_prereq: "Lmm"},

      {round: 11, bracket_uid: "jj", home_prereq: "Whh", away_prereq: "Wii"},
    ]
  end

  pool '4.1', 'F', ["Lz","Laa","Lbb","Lcc"]
  pool '3.1', 'G', ["Lw","Lv","E1"]
  pool '3.1', 'H', ["Ly","Lx","Wrr"]

  games do
    [
      {round: 10, bracket_uid: "bbb", home_prereq: "G1", away_prereq: "H1"},
      {round: 10, bracket_uid: "ccc", home_prereq: "G2", away_prereq: "H2"},
      {round: 10, bracket_uid: "ddd", home_prereq: "G3", away_prereq: "H3"},
    ]
  end

  pool '5.1.1', 'J', ["Lrr","Wss","Lss","E2","E3"]

  places %w(Wjj Ljj Wkk Lkk Wnn Lnn Woo Loo F1 F2 F3 F4 Wbbb Lbbb Wccc Lccc Wddd Lddd J1 J2 J3 J4 J5)
end

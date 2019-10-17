BracketDb.define "CUUC Women 2019 Div II" do
  name "CUUC 2019 Women's Division II"
  teams 11
  days 2

  pool '5.1.1', 'E', [1, 4, 5, 8, 9]

  pool '3.1', 'G', [2, 6, 10]
  pool '3.1', 'H', [3, 7, 11]

  games [
    {round:1, bracket_uid: "F1", home_prereq: "G1", away_prereq: "H1"},
    {round:1, bracket_uid: "F3", home_prereq: "G2", away_prereq: "H2"},
    {round:1, bracket_uid: "F5", home_prereq: "G3", away_prereq: "H3"}
  ]

  games [
    {round:1, bracket_uid: "o", home_prereq: "E3", away_prereq: "LF1"},
    {round:1, bracket_uid: "q", home_prereq: "WF3", away_prereq: "E2"},

    {round:2, bracket_uid: "v", home_prereq: "Lo", away_prereq: "Lq"},

    {round:3, bracket_uid: "r", home_prereq: "E1", away_prereq: "Wo"},
    {round:3, bracket_uid: "s", home_prereq: "WF1", away_prereq: "Wq"},

    {round:4, bracket_uid: "t", home_prereq: "Wr", away_prereq: "Ws"},
    {round:4, bracket_uid: "u", home_prereq: "Lr", away_prereq: "Ls"}
  ]

  pool(
    [
      {round:1,  home_pool_seed: 2, away_pool_seed: 5},
      {round:1,  home_pool_seed: 3, away_pool_seed: 4},
      {round:2,  home_pool_seed: 2, away_pool_seed: 4},
      {round:2,  home_pool_seed: 1, away_pool_seed: 3},
      {round:3,  home_pool_seed: 1, away_pool_seed: 2},
      {round:3,  home_pool_seed: 3, away_pool_seed: 5}
    ],
    "I",
    %w(LF3 E4 E5 WF5 LF5)
  )

  places %w(Wt Lt Wu Lu Wv Lv I1 I2 I3 I4 I5)
end

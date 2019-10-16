BracketDb.define "CUUC Women 2019 Div II" do
  name "CUUC 2019 Women's Division II"
  teams 11
  days 2

  pool '5.1.1', 'E', [1, 4, 5, 8, 9]

  pool(
    [
      {round: 1, home_pool_seed: 1, away_pool_seed: 5},
      {round: 1, home_pool_seed: 2, away_pool_seed: 6},
      {round: 2, home_pool_seed: 3, away_pool_seed: 5},
      {round: 2, home_pool_seed: 4, away_pool_seed: 6},
      {round: 3, home_pool_seed: 1, away_pool_seed: 3},
      {round: 3, home_pool_seed: 2, away_pool_seed: 4},


      {round: 4, home_pool_seed: 1, away_pool_seed: 2},
      {round: 4, home_pool_seed: 3, away_pool_seed: 4},
      {round: 4, home_pool_seed: 5, away_pool_seed: 6},
      {round: 5, home_pool_seed: 2, away_pool_seed: 3},
      {round: 5, home_pool_seed: 4, away_pool_seed: 5},
      {round: 5, home_pool_seed: 1, away_pool_seed: 6},
      {round: 6, home_pool_seed: 2, away_pool_seed: 5},
      {round: 6, home_pool_seed: 1, away_pool_seed: 4},
      {round: 6, home_pool_seed: 3, away_pool_seed: 6}
    ],
    'F',
    [2, 3, 6, 7, 10, 11]
  )

  games [
    {round:1, bracket_uid: "o", home_prereq: "E3", away_prereq: "F2"},
    {round:1, bracket_uid: "q", home_prereq: "F3", away_prereq: "E2"},

    {round:2, bracket_uid: "v", home_prereq: "Lo", away_prereq: "Lq"},

    {round:3, bracket_uid: "r", home_prereq: "E1", away_prereq: "Wo"},
    {round:3, bracket_uid: "s", home_prereq: "F1", away_prereq: "Wq"},

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
    %w(F4 E4 E5 F5 F6)
  )

  places %w(Wt Lt Wu Lu Wv Lv I1 I2 I3 I4 I5)
end

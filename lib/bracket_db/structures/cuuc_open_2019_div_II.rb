BracketDb.define "CUUC Open 2019 Div II" do
  name "CUUC 2019 Open Division II"
  teams 24
  days 2

  pool '3.1', 'J', [1, 16, 17]
  pool '3.1', 'K', [2, 15, 18]
  pool '3.1', 'M', [3, 14, 19]
  pool '3.1', 'N', [4, 13, 20]
  pool '3.1', 'O', [5, 12, 21]
  pool '3.1', 'P', [6, 11, 22]
  pool '3.1', 'Q', [7, 10, 23]
  pool '3.1', 'R', [8, 9, 24]

  pool '4.1', 'S', %w(J1 Q1 J2 Q2)
  pool '4.1', 'U', %w(K1 R1 K2 R2)
  pool '4.1', 'T', %w(M1 O1 M2 O2)
  pool '4.1', 'V', %w(N1 P1 N2 P2)

  # Pool X
  games [
    { round: 1, bracket_uid: "aa", home_prereq: "J3", away_prereq: "Q3" },
    { round: 1, bracket_uid: "ab", home_prereq: "M3", away_prereq: "O3" },

    { round: 2, bracket_uid: "ac", home_prereq: "Waa", away_prereq: "Wab" },
    { round: 2, bracket_uid: "ad", home_prereq: "Laa", away_prereq: "Lab" }
  ]

  # RE-RANK
  # 1X	1X Wac
  # 2X	2X Lac
  # 3X	3X Wad
  # 4X	4X Lad

  # Pool Y
  games [
    { round: 1, bracket_uid: "ae", home_prereq: "K3", away_prereq: "R3" },
    { round: 1, bracket_uid: "af", home_prereq: "N3", away_prereq: "P3" },

    { round: 2, bracket_uid: "ag", home_prereq: "Wae", away_prereq: "Waf" },
    { round: 2, bracket_uid: "ah", home_prereq: "Lae", away_prereq: "Laf" }
  ]

  # RE-RANK
  # 1Y	1Y Wag
  # 2Y	2Y Lag
  # 3Y	3Y Wah
  # 4Y	4Y Lah

  # 1 to 8
  games [
    {round: 1, bracket_uid: "ba", home_prereq: "S1", away_prereq: "U2"},
    {round: 1, bracket_uid: "bb", home_prereq: "V1", away_prereq: "T2"},
    {round: 1, bracket_uid: "bc", home_prereq: "T1", away_prereq: "V2"},
    {round: 1, bracket_uid: "bd", home_prereq: "U1", away_prereq: "S2"},

    {round: 2, bracket_uid: "be", home_prereq: "Wba", away_prereq: "Wbb"},
    {round: 2, bracket_uid: "bf", home_prereq: "Wbc", away_prereq: "Wbd"},

    {round: 3, bracket_uid: "bi", home_prereq: "Lbc", away_prereq: "Lbd"},
    {round: 3, bracket_uid: "bj", home_prereq: "Lba", away_prereq: "Lbb"},

    {round: 4, bracket_uid: "bg", home_prereq: "Wbe", away_prereq: "Wbf"},
    {round: 4, bracket_uid: "bh", home_prereq: "Lbe", away_prereq: "Lbf"},
    {round: 4, bracket_uid: "bk", home_prereq: "Wbi", away_prereq: "Wbj"},
    {round: 4, bracket_uid: "bm", home_prereq: "Lbi", away_prereq: "Lbj"}
  ]

  # 9 to 12
  games [
    { round: 1, bracket_uid: "bn", home_prereq: "S3", away_prereq: "U3" },
    { round: 1, bracket_uid: "bo", home_prereq: "T3", away_prereq: "V3" },

    { round: 2, bracket_uid: "bp", home_prereq: "Wbn", away_prereq: "Wbo" },
    { round: 2, bracket_uid: "bq", home_prereq: "Lbn", away_prereq: "Lbo" }
  ]

  # 13 to 20
  games [
    {round: 1, bracket_uid: "br", home_prereq: "V4", away_prereq: "Lac"},
    {round: 1, bracket_uid: "bs", home_prereq: "S4", away_prereq: "Wag"},
    {round: 1, bracket_uid: "bt", home_prereq: "T4", away_prereq: "Wac"},
    {round: 1, bracket_uid: "bu", home_prereq: "U4", away_prereq: "Lag"},

    {round: 2, bracket_uid: "ca", home_prereq: "Lbr", away_prereq: "Lbs"},
    {round: 2, bracket_uid: "cb", home_prereq: "Lbt", away_prereq: "Lbu"},

    {round: 3, bracket_uid: "bv", home_prereq: "Wbr", away_prereq: "Wbs"},
    {round: 3, bracket_uid: "bx", home_prereq: "Wbt", away_prereq: "Wbu"},

    {round: 4, bracket_uid: "by", home_prereq: "Wbv", away_prereq: "Wbx"},
    {round: 4, bracket_uid: "bz", home_prereq: "Lbv", away_prereq: "Lbx"},
    {round: 4, bracket_uid: "cc", home_prereq: "Wca", away_prereq: "Wcb"},
    {round: 4, bracket_uid: "cd", home_prereq: "Lca", away_prereq: "Lcb"}
  ]

  # 21 to 24
  pool(
    [
      {round: 1, home_pool_seed: 1, away_pool_seed: 4},
      {round: 1, home_pool_seed: 2, away_pool_seed: 3},

      {round: 2, home_pool_seed: 1, away_pool_seed: 2},
      {round: 2, home_pool_seed: 3, away_pool_seed: 4}
    ],
    "Z",
    %w(Wah Wad Lah Lad)
  )

  places %w(Wbg Lbg Wbh Lbh Wbk Lbk Wbm Lbm Wbp Lbp Wbq Lbq Wby Lby Wbz Lbz Wcc Lcc Wcd Lcd Z1 Z2 Z3 Z4)
end

BracketDb.define 'simple_8' do
  name 'Single Elimination (No Loser Bracket)'
  teams 8
  days 1

  games [
    {round: 1, "seed_round": 1, bracket_uid: "q1", home_prereq: 1, away_prereq: "8"},
    {round: 1, "seed_round": 1, bracket_uid: "q2", home_prereq: 2, away_prereq: "7"},
    {round: 1, "seed_round": 1, bracket_uid: "q3", home_prereq: 3, away_prereq: "6"},
    {round: 1, "seed_round": 1, bracket_uid: "q4", home_prereq: 4, away_prereq: "5"},

    {round: 2, bracket_uid: "s1", home_prereq: "Wq1", away_prereq: "Wq4"},
    {round: 2, bracket_uid: "s2", home_prereq: "Wq2", away_prereq: "Wq3"},

    {round: 3, bracket_uid: "1", home_prereq: "Ws1", away_prereq: "Ws2"}
  ]

  places %w(W1 L1 Ls1 Ls2 Lq2 Lq3 Lq4 Lq1)
end

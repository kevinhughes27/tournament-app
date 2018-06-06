BracketDb.define 'single_elimination_4' do
  name 'Single Elimination'
  teams 4
  days 1

  games [
    {round: 1, seed_round: 1, bracket_uid: "s1", home_prereq: "1", away_prereq: "4"},
    {round: 1, seed_round: 1, bracket_uid: "s2", home_prereq: "2", away_prereq: "3"},

    {round: 2, bracket_uid: "1", home_prereq: "Ws1", away_prereq: "Ws2"},
    {round: 2, bracket_uid: "3", home_prereq: "Ls1", away_prereq: "Ls2"}
  ]

  places %w(W1 L1 W3 L3)
end

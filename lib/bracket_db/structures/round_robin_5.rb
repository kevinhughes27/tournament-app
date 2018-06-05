BracketDb.define 'ROUND_ROBIN_5' do
  name 'Round Robin'
  teams 5
  days 1

  games do
    [
      {round: 1, "seed_round": 1, bracket_uid: "rr1", home_prereq: 2, away_prereq: 5},
      {round: 1, "seed_round": 1, bracket_uid: "rr2", home_prereq: 3, away_prereq: 4},

      {round: 2, "seed_round": 1, bracket_uid: "rr3", home_prereq: "Wrr1", away_prereq: 1},

      {round: 3, bracket_uid: "3", home_prereq: "Lrr1", away_prereq: "Lrr2"},
      {round: 3, bracket_uid: "1", home_prereq: "Wrr3", away_prereq: "Wrr2"}
    ]
  end

  places %w(W1 L1 W3 L3 Lrr3)
end

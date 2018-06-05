BracketDb.define 'POWER_POOLS_6' do
  name 'Power Pools'
  teams 6
  days 1

  pool '3.1', 'A', [1,4,5]
  pool '3.1', 'B', [2,3,6]

  games do
    [
      {round:1, bracket_uid: "a", home_prereq: "A1", away_prereq: "B2"},
      {round:1, bracket_uid: "b", home_prereq: "B1", away_prereq: "A2"},
      {round:1, bracket_uid: "c", home_prereq: "A3", away_prereq: "B3"},

      {round:2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"}
    ]
  end

  places %w(W1 L1 La Lb Wc Lc)
end

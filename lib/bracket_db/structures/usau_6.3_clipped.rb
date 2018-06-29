BracketDb.define 'USAU 6.3 Clipped' do
  name 'Three teams advance (USAU 6.3) with a clipped 2 round bracket'
  description 'Pool games are played over 2 days.'
  teams 6
  days 2

  pool '6.1.4', 'A', [1,2,3,4,5,6]

  games [
    # bracket 6.3
    {round:1, bracket_uid: "1", home_prereq: "A1", away_prereq: "A2"},
    {round:1, bracket_uid: "b", home_prereq: "A3", away_prereq: "A6"},
    {round:1, bracket_uid: "c", home_prereq: "A5", away_prereq: "A4"},

    {round:2, bracket_uid: "3", home_prereq: "Wb", away_prereq: "Wc"},
    {round:2, bracket_uid: "5", home_prereq: "Lb", away_prereq: "Lc"},
  ]

  places %w(W1 L1 W3 L3 W5 L5)
end

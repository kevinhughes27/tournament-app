BracketDb.define 'USAU 7.3' do
  name 'Three teams advance (USAU 7.3)'
  description 'Pool games are played over 2 days.'
  teams 7
  days 2

  pool '7.1.1', 'A', [1,2,3,4,5,6,7]

  games [
    {round:1, bracket_uid: "1", home_prereq: "A1", away_prereq: "A2"},
    {round:1, bracket_uid: "b", home_prereq: "A3", away_prereq: "A6"},
    {round:1, bracket_uid: "c", home_prereq: "A5", away_prereq: "A4"},

    {round:2, bracket_uid: "3", home_prereq: "Wb", away_prereq: "Wc"}
  ]

  places %w(W1 L1 W3 L3 Lb Lc A7)
end

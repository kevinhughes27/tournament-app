BracketDb.define 'USAU 7.6' do
  name 'Six teams advance (USAU 7.6)'
  description 'Pool games are played over 2 days. 3rd place is from pool play.'
  teams 7
  days 2

  pool '7.1.2', 'A', [1,2,3,4,5,6,7]

  games [
    {round:1, bracket_uid: "1", home_prereq: "A1", away_prereq: "A2"},
    {round:1, bracket_uid: "b", home_prereq: "A4", away_prereq: "A7"},
    {round:1, bracket_uid: "c", home_prereq: "A5", away_prereq: "A6"},

    {round:2, bracket_uid: "6", home_prereq: "Lb", away_prereq: "Lc"}
  ]

  places %w(W1 L1 A3 Wb Wc W6 L6)
end

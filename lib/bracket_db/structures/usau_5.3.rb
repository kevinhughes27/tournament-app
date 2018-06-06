BracketDb.define 'USAU 5.3' do
  name 'Three teams advance (USAU 5.3)'
  description 'This format requires seven rounds, five for the round-robin and two for the elimination bracket. The top seed and the bottom finisher will only get one game on Sunday. This is almost unavoidable, given the desire to keep all five teams in contention.'
  teams 5
  days 2

  pool '5.1.2', 'A', [1,2,3,4,5]

  games [
    {round:1, bracket_uid: "a", home_prereq: "A2", away_prereq: "A3"},
    {round:2, bracket_uid: "1", home_prereq: "A1", away_prereq: "Wa"},

    {round:1, bracket_uid: "c", home_prereq: "A4", away_prereq: "A5"},
    {round:2, bracket_uid: "3", home_prereq: "Wc", away_prereq: "La"}
  ]

  places %w(W1 L1 W3 L3 Lc)
end

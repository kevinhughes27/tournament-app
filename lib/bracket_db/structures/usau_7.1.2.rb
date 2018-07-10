BracketDb.define 'USAU 7.1.2' do
  name 'Seven Teams Advance using USAU 7.1.2'
  description 'Pool games are split over two days'
  teams 7
  days 2

  pool '7.1.2', 'A', [1,2,3,4,5,6,7]

  games [
    {round:1, bracket_uid: "1", home_prereq: "A1", away_prereq: "A2"},
  ]

  places %w(W1 L1 A3 A4 A5 A6 A7)
end

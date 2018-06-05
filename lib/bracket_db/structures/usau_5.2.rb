BracketDb.define 'USAU_5.2' do
  name 'Two teams advance (USAU 5.2)'
  description 'This format requires seven rounds, five for the round-robin and two for the clipped double-elimination. The most games a team will play is six.'
  teams 5
  days 2

  pool '5.1.2', 'A', [1,2,3,4,5]

  games do
    [
      {round:1, bracket_uid: "1", home_prereq: "A1", away_prereq: "A2"},
      {round:1, bracket_uid: "b", home_prereq: "A3", away_prereq: "A4"},

      {round:2, bracket_uid: "2", home_prereq: "Wb", away_prereq: "L1"}
    ]
  end

  places %w(W1 W2 L2 Lb A5)
end

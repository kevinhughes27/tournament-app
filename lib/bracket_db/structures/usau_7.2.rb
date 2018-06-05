BracketDb.define 'USAU_7.2' do
  name 'Two teams advance (USAU 7.2)'
  description 'Pool games are played over 2 days.'
  teams 7
  days 2

  pool '7.1.1', 'A', [1,2,3,4,5,6,7]

  games do
    [
      {round:1, bracket_uid: "1", home_prereq: "A1", away_prereq: "A2"},
      {round:1, bracket_uid: "b", home_prereq: "A3", away_prereq: "A4"},

      {round:2, bracket_uid: "2", home_prereq: "Wb", away_prereq: "L1"}
    ]
  end

  places %w(W1 W2 L2 Lb A5 A6 A7)
end

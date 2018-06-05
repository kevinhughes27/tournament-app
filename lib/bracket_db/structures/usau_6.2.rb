BracketDb.define 'USAU_6.2' do
  name 'Two teams advance (USAU 6.2)'
  description 'Pool games are played to 13 and over 2 days.'
  teams 6
  days 2

  pool '6.1.4', 'A', [1,2,3,4,5,6]

  games do
    [
      {round:1, bracket_uid: "1", home_prereq: "A1", away_prereq: "A2"},
      {round:1, bracket_uid: "b", home_prereq: "A3", away_prereq: "A4"},
      {round:1, bracket_uid: "5", home_prereq: "A5", away_prereq: "A6"},

      {round:2, bracket_uid: "2", home_prereq: "Wb", away_prereq: "L1"}
    ]
  end

  places %w(W1 W2 L2 Lb W5 L5)
end

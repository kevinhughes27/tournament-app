BracketDb.define 'USAU 7.7' do
  name 'Seven teams advance (USAU 7.7)'
  description 'Pool games are played over 2 days.'
  teams 7
  days 2

  pool '7.1.1', 'A', [1,2,3,4,5,6,7]

  games do
    [
      {round:1, bracket_uid: "a", home_prereq: "A1", away_prereq: "A4"},
      {round:1, bracket_uid: "b", home_prereq: "A2", away_prereq: "A3"},

      {round:2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"}
    ]
  end

  places %w(W1 L1 La Lb A5 A6 A7)
end

BracketDb.define 'USAU 6.1' do
  name 'One team advances (USAU 6.1)'
  description 'Pool games are played to 13 and over 2 days.'
  teams 6
  days 2

  pool '6.1.4', 'A', [1,2,3,4,5,6]

  games do
    [
      {round:1, bracket_uid: "a", home_prereq: "A1", away_prereq: "A4"},
      {round:1, bracket_uid: "b", home_prereq: "A2", away_prereq: "A3"},
      {round:1, bracket_uid: "5", home_prereq: "A5", away_prereq: "A6"},

      {round:2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"},
      {round:2, bracket_uid: "3", home_prereq: "La", away_prereq: "Lb"}
    ]
  end

  places %w(W1 L1 W3 L3 W5 L5)
end

BracketDb.define 'USAU 5.5' do
  name 'Five teams advance (USAU 5.5)'
  teams 5
  days 2

  pool '5.1.2', 'A', [1,2,3,4,5]

  games do
    [
      {round:1, bracket_uid: "a", home_prereq: "A1", away_prereq: "A4"},
      {round:1, bracket_uid: "b", home_prereq: "A2", away_prereq: "A3"},

      {round:2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"},
      {round:2, bracket_uid: "3", home_prereq: "La", away_prereq: "Lb"}
    ]
  end

  places %w(W1 L1 W3 L3 A5)
end

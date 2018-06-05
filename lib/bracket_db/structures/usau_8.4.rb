BracketDb.define 'USAU 8.4' do
  name 'Four teams advance (USAU 8.4)'
  teams 8
  days 2

  pool '4.1', 'A', [1,4,5,8]
  pool '4.1', 'B', [2,3,6,7]

  games do
    [
      {round: 1, bracket_uid: "1", home_prereq: "A1", away_prereq: "B1"},
      {round: 1, bracket_uid: "b", home_prereq: "A2", away_prereq: "B2"},
      {round: 2, bracket_uid: "2", home_prereq: "L1", away_prereq: "Wb"},

      {round: 1, bracket_uid: "d", home_prereq: "A3", away_prereq: "B4"},
      {round: 1, bracket_uid: "e", home_prereq: "A4", away_prereq: "B3"},
      {round: 2, bracket_uid: "f", home_prereq: "Wd", away_prereq: "We"},

      {round: 3, bracket_uid: "4", home_prereq: "Lb", away_prereq: "Wf"},
      {round: 3, bracket_uid: "7", home_prereq: "Ld", away_prereq: "Le"}
    ]
  end

  places %w(W1 W2 L2 W4 L4 Lf W7 L7)
end

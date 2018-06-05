BracketDb.define 'USAU_9.2' do
  name 'Two teams advance (USAU 9.2)'
  description 'The pool of five plays games to 11, while the pool of four plays games to 15 in order to balance the total number of points played between pools.'
  teams 9
  days 2

  pool '5.1.3', 'A', [1,3,6,8,9]
  pool '4.1', 'B', [2,4,5,7]

  games do
    [
      {round: 1, bracket_uid: "a", home_prereq: "A1", away_prereq: "B2"},
      {round: 1, bracket_uid: "b", home_prereq: "A2", away_prereq: "B1"},
      {round: 2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"},

      {round: 1, bracket_uid: "d", home_prereq: "A3", away_prereq: "B4"},
      {round: 1, bracket_uid: "e", home_prereq: "A4", away_prereq: "B3"},
      {round: 2, bracket_uid: "f", home_prereq: "La", away_prereq: "Wd"},
      {round: 2, bracket_uid: "g", home_prereq: "We", away_prereq: "Lb"},

      {round: 3, bracket_uid: "h", home_prereq: "Wf", away_prereq: "Wg"},
      {round: 4, bracket_uid: "2", home_prereq: "L1", away_prereq: "Wh"},

      {round: 3, bracket_uid: "5", home_prereq: "Lf", away_prereq: "Lg"},
      {round: 3, bracket_uid: "7", home_prereq: "Ld", away_prereq: "Le"}
    ]
  end

  places %w(W1 W2 L2 Lh W5 L5 W7 L7 A5)
end

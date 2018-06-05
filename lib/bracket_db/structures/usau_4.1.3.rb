BracketDb.define 'USAU_4.1.3' do
  name 'Three teams advance (USAU 4.1.3)'
  description 'The last game for second place can be left unplayed since both teams have qualified already.'
  teams 4
  days 1

  games do
    [
      {round:1, "seed_round":1, bracket_uid: "a", home_prereq: "1", away_prereq: "4"},
      {round:1, "seed_round":1, bracket_uid: "b", home_prereq: "2", away_prereq: "3"},

      {round:2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"},
      {round:2, bracket_uid: "d", home_prereq: "La", away_prereq: "Lb"},

      {round:3, bracket_uid: "2", home_prereq: "Wd", away_prereq: "L1"}
    ]
  end

  places %w(W1 W2 L2 Ld)
end

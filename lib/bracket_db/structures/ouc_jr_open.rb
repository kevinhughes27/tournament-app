BracketDb.define 'OUC_JR_OPEN' do
  name 'Ontario Junior Open 2017'
  teams 10
  days 2

  pool '5.1.1', 'A', [1,3,5,7,9]
  pool '5.1.1', 'B', [2,4,6,8,10]

  games do
    [
      {round:1, bracket_uid: "G1", home_prereq: "A3", away_prereq: "B2"},
      {round:1, bracket_uid: "G2", home_prereq: "A2", away_prereq: "B3"},
      {round:1, bracket_uid: "G7", home_prereq: "A4", away_prereq: "B5"},
      {round:1, bracket_uid: "G8", home_prereq: "A5", away_prereq: "B4"},

      {round:2, bracket_uid: "G3", home_prereq: "A1", away_prereq: "WG1"},
      {round:2, bracket_uid: "G4", home_prereq: "B1", away_prereq: "WG2"},
      {round:2, bracket_uid: "G9", home_prereq: "WG7", away_prereq: "LG1"},
      {round:2, bracket_uid: "G10", home_prereq: "WG8", away_prereq: "LG2"},

      {round:3, bracket_uid: "9", home_prereq: "LG7", away_prereq: "LG8"},

      {round:3, bracket_uid: "1", home_prereq: "WG3", away_prereq: "WG4"},
      {round:3, bracket_uid: "3", home_prereq: "LG3", away_prereq: "LG4"},
      {round:3, bracket_uid: "5", home_prereq: "WG9", away_prereq: "WG10"},
      {round:3, bracket_uid: "7", home_prereq: "LG9", away_prereq: "LG10"}
    ]
  end

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9)
end

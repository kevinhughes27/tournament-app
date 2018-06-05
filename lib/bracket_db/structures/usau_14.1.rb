BracketDb.define 'USAU 14.1' do
  name 'One team advances (USAU 14.1)'
  description 'Teams not in the bracket play a final game against their matching finish in the opposite pool'
  teams 14
  days 2

  pool '7.1.1', 'A', [1,3,6,8,9,12,13]
  pool '7.1.1', 'B', [2,4,5,7,10,11,14]

  games do
    [
      {round:1, bracket_uid: "a", home_prereq: "A1", away_prereq: "B2"},
      {round:1, bracket_uid: "b", home_prereq: "B1", away_prereq: "A2"},

      {round:2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"},
      {round:2, bracket_uid: "3", home_prereq: "La", away_prereq: "Lb"},

      {round:1, bracket_uid: "5", home_prereq: "A3", away_prereq: "B3"},
      {round:1, bracket_uid: "7", home_prereq: "A4", away_prereq: "B4"},
      {round:1, bracket_uid: "9", home_prereq: "A5", away_prereq: "B5"},
      {round:1, bracket_uid: "11", home_prereq: "A6", away_prereq: "B6"},
      {round:1, bracket_uid: "13", home_prereq: "A7", away_prereq: "B7"}
    ]
  end

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9 W11 L11 W13 L13)
end

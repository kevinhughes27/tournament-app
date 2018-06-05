BracketDb.define 'USAU_17.1' do
  name 'One team advances (USAU 17.1)'
  teams 17
  days 2

  pool '5.1.2', 'A', [1,8,12,13,17]
  pool '4.1', 'B', [2,7,11,14]
  pool '4.1', 'C', [3,6,10,15]
  pool '4.1', 'D', [4,5,9,16]

  bracket '16.1'

  # usau_5.3
  games do
    [
      {round:1, bracket_uid: "aa", home_prereq: "B4", away_prereq: "C4"},
      {round:2, bracket_uid: "13", home_prereq: "A4", away_prereq: "Waa"},

      {round:1, bracket_uid: "cc", home_prereq: "D4", away_prereq: "A5"},
      {round:2, bracket_uid: "15", home_prereq: "Wcc", away_prereq: "Laa"}
    ]
  end

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9 W11 L11)
  places %w(W13 L13 W15 L15 Lcc)
end

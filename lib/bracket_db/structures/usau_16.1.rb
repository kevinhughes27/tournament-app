BracketDb.define 'USAU_16.1' do
  name 'One team advances (USAU 16.1)'
  teams 16
  days 2

  pool '4.1', 'A', %w(1 8  9 16)
  pool '4.1', 'B', %w(2 7 10 15)
  pool '4.1', 'C', %w(3 6 11 14)
  pool '4.1', 'D', %w(4 5 12 12)

  bracket '16.1'

  games do
    [
      {round: 1, bracket_uid: "aa", home_prereq: "A4", away_prereq: "D4"},
      {round: 1, bracket_uid: "bb", home_prereq: "B4", away_prereq: "C4"},

      {round: 2, bracket_uid: "13", home_prereq: "Waa", away_prereq: "Wbb"},
      {round: 2, bracket_uid: "15", home_prereq: "Laa", away_prereq: "Lbb"}
    ]
  end

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9 W11 L11)
  places %w(W13 L13 W15 L15)
end

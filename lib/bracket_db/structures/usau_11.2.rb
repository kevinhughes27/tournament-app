BracketDb.define 'USAU 11.2' do
  name 'Two teams advance (USAU 11.2)'
  teams 11
  days 2

  pool '5.1.1', 'A', [1,3,6,8,9]
  pool '6.1.2', 'B', [2,4,5,7,10,11]

  bracket '8.2.1'

  games do
    [
      {round:1, bracket_uid: "aa", home_prereq: "A5", away_prereq: "B6"},
      {round:2, bracket_uid: "9", home_prereq: "Waa", away_prereq: "B5"}
    ]
  end

  places %w(W1 W2 L2 Lh W5 L5 W7 L7 W9 L9 Laa)
end

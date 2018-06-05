BracketDb.define 'USAU 10.1' do
  name 'One team advances (USAU 10.1)'
  teams 10
  days 2

  pool '5.1.1', 'A', [1,3,6,8,9]
  pool '5.1.3', 'B', [2,4,5,7,10]

  bracket '8.1'

  games do
    [
      {round:1, bracket_uid: "9", home_prereq: "A5", away_prereq: "B5"}
    ]
  end

  places %w(W1 L1 W3 L3 W5 L5 W7 L7 W9 L9)
end

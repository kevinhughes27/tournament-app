BracketDb.define 'USAU_7.5' do
  name 'Five teams advance (USAU 7.5)'
  description 'Pool games are played over 2 days. 3rd place is determined from pool play.'
  teams 7
  days 2

  pool '7.1.2', 'A', [1,2,3,4,5,6,7]

  games do
    [
      {round:1, bracket_uid: "1", home_prereq: "A1", away_prereq: "A2"},
      {round:1, bracket_uid: "4", home_prereq: "A4", away_prereq: "A5"},
      {round:1, bracket_uid: "d", home_prereq: "A6", away_prereq: "A7"},

      {round:2, bracket_uid: "5", home_prereq: "L4", away_prereq: "Wd"}
    ]
  end

  places %w(W1 L1 A3 W4 W5 L5 Ld)
end

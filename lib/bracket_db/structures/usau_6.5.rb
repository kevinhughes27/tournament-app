BracketDb.define 'USAU 6.5' do
  name 'Five teams advance (USAU 6.5)'
  description 'Pool games are played to 13 and over 2 days.'
  teams 6
  days 2

  pool '6.1.4', 'A', [1,2,3,4,5,6]

  games [
    {round:1, bracket_uid: "a", home_prereq: "A4", away_prereq: "A5"},
    {round:1, bracket_uid: "b", home_prereq: "A3", away_prereq: "A6"},

    {round:2, bracket_uid: "c", home_prereq: "A1", away_prereq: "Wa"},
    {round:2, bracket_uid: "d", home_prereq: "A2", away_prereq: "Wb"},
    {round:2, bracket_uid: "5", home_prereq: "La", away_prereq: "Lb"},

    {round:3, bracket_uid: "1", home_prereq: "Wc", away_prereq: "Wd"},
    {round:3, bracket_uid: "3", home_prereq: "Lc", away_prereq: "Ld"}
  ]

  places %w(W1 L1 W3 L3 W5 L5)
end

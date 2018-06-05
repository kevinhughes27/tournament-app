BracketDb.define 'CUUC 7' do
  name "CUUC Women's Qualifier"
  teams 7
  days 1

  pool '3.1', 'O', [1,4,5]
  pool '4.1', 'P', [2,3,6,7]

  games do
    [
      {round:1, bracket_uid: "zz", home_prereq: "O1", away_prereq: "P1"},
      {round:1, bracket_uid: "xx", home_prereq: "O2", away_prereq: "P4"},
      {round:1, bracket_uid: "yy", home_prereq: "O3", away_prereq: "P3"},
    ]
  end

  places %w(Wzz Lzz P2 Wxx Wyy Lxx Lyy)
end

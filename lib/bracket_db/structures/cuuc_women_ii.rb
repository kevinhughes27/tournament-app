BracketDb.define 'CUUC_WOMEN_II' do
  name 'CUUC Womens Div II'
  teams 13
  days 2

  pool '3.1', 'Q', [1,8,9]
  pool '3.1', 'R', [2,7,10]
  pool '3.1', 'S', [3,6,11]
  pool '4.1', 'T', [4,5,12,13]

  pool '4.1', 'X', ['Q1', 'T1', 'T2', 'Q2']
  pool '4.1', 'Y', ['R1', 'S1', 'S2', 'R2']
  pool '5.1.1', 'Z', ['Q3', 'R3', 'S3', 'T3', 'T4']

  games do
    [
      {round:1, bracket_uid: "tt", home_prereq: "Y1", away_prereq: "X2"},
      {round:1, bracket_uid: "uu", home_prereq: "X1", away_prereq: "Y2"},

      {round:2, bracket_uid: "vv", home_prereq: "Wtt", away_prereq: "Wuu"},
      {round:2, bracket_uid: "ww", home_prereq: "Ltt", away_prereq: "Luu"},

      {round:1, bracket_uid: "xx", home_prereq: "Y3", away_prereq: "X4"},
      {round:1, bracket_uid: "yy", home_prereq: "X3", away_prereq: "Y4"},

      {round:2, bracket_uid: "zz", home_prereq: "Wxx", away_prereq: "Wyy"},
      {round:2, bracket_uid: "aaa", home_prereq: "Lxx", away_prereq: "Lyy"}
    ]
  end

  places %w(Wvv Lvv Www Lww Wzz Lzz Waaa Laaa Z1 Z2 Z3 Z4 Z5)
end

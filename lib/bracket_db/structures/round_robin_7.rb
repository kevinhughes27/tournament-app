BracketDb.define 'round_robin_7' do
  name 'Round Robin'
  description 'Pool games are played over 2 days.'
  teams 7
  days 2

  pool '7.1.1', 'R', [1,2,3,4,5,6,7]

  places %w(R1 R2 R3 R4 R5 R6 R7)
end

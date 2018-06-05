BracketDb.define 'USAU_8.1' do
  name 'One team advances (USAU 8.1)'
  description 'The first day has two pools of four and the second day is a single elimination bracket.'
  teams 8
  days 2

  pool '4.1', 'A', %w(1 3 6 8)
  pool '4.1', 'B', %w(2 4 5 7)

  bracket '8.1'

  places %w(W1 L1 W3 L3 W5 L5 W7 L7)
end

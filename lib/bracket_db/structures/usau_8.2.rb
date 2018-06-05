BracketDb.define 'USAU_8.2' do
  name 'Two teams advance (USAU 8.2)'
  description 'The first day has two pools of four and the second day is a clipped double elimination bracket.'
  teams 8
  days 2

  pool '4.1', 'A', %w(1 3 6 8)
  pool '4.1', 'B', %w(2 4 5 7)

  bracket '8.2.1'

  places %w(W1 W2 L2 Lh W5 L5 W7 L7)
end

require_relative 'bracket_db'
require 'byebug'
require 'pp'


BracketDb.define 'USAU_8.1' do
  description 'One team advances (USAU 8.1)'
  teams 8
  days 2

  stage :pools do
    pool 'A', '4.1', %w(1 3 6 8)
    pool 'B', '4.1', %w(2 4 5 7)
  end

  stage :bracket do
    bracket '8.1', %w(A1 B4 B2 A3 A2 B3 B1 A4)
  end

  stage :results do
    %w(W1 L1 W3 L3 W5 L5 W7 L7)
  end
end


BracketDb.print('USAU_8.1')

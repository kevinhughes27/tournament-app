require_relative './usau_81'
require 'byebug'

br = BracketDb::USAU_81

if br.stages == ['pool', 'bracket']
  puts 'PASS'
else
  puts 'FAIL'
end

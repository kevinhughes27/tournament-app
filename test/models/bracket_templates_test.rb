require 'test_helper'

class BracketTemplatesTest < ActiveSupport::TestCase
  Bracket.all.each do |bracket|
    test "bracket template #{bracket.name}" do
      assert BracketTemplateValidator::validate(bracket.template), 'invalid bracket'
    end
  end
end

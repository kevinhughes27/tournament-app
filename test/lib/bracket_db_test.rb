require 'test_helper'

class BracketTest < ActiveSupport::TestCase
  BracketDb::TemplateValidator.methods(false).each do |validation|
    next unless validation.to_s.include? 'validate_'
    BracketDb.all.each do |bracket|
      test "bracket template #{validation} #{bracket.handle}" do
        assert BracketDb::TemplateValidator.send(validation, bracket.template)
      end
    end
  end
end

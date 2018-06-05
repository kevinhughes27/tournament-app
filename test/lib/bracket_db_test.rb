require 'test_helper'

class BracketDbTest < ActiveSupport::TestCase
  BracketDb::TemplateValidator.methods(false).each do |validation|
    next unless validation.to_s.include? 'validate_'
    BracketDb.all.each do |handle, bracket|
      test "bracket template #{validation} #{handle}" do
        assert BracketDb::TemplateValidator.send(validation, bracket.template)
      end
    end
  end
end

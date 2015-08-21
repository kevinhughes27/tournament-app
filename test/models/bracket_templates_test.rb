require 'test_helper'

class BracketTemplatesTest < ActiveSupport::TestCase

  BracketDb.types.each do |template_name|
    test "bracket template #{template_name}" do
      template = BracketDb[template_name]
      assert BracketTemplateValidator::validate(template)
    end
  end

end

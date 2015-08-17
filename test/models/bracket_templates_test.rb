require 'test_helper'

class BracketTemplatesTest < ActiveSupport::TestCase

  Bracket.types.each do |template_name|
    test "bracket template #{template_name}" do
      template = load_template(template_name)
      assert BracketTemplateValidator::validate(template)
    end
  end

  def load_template(name)
    path = File.join(Bracket::TEMPLATE_PATH, "#{name}.json")
    file = File.read(path)
    JSON.parse(file).with_indifferent_access
  end

end

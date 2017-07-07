require 'test_helper'

class BuilderHelperTest < ActionView::TestCase
  test "builder card default animation is bounceInRight" do
    card = builder_card{ "test" }
    assert_match /bounceInRight/, card
  end

  test "builder card animation is pulse if there is an error" do
    card = builder_card(error: true){ "test" }
    assert_match /pulse/, card
  end

  test "builder card animation is bounceInLeft if navigation is back" do
    card = builder_card(error: false, back: true){ "test" }
    assert_match /bounceInLeft/, card
  end
end

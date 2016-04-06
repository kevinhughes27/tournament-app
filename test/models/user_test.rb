require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "kevin is staff" do
    assert users(:kevin).staff?
  end

  test "sam is staff" do
    assert users(:sam).staff?
  end

  test "bob is not staff" do
    refute users(:bob).staff?
  end
end

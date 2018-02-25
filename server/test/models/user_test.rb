require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "kevin is staff" do
    user = FactoryGirl.build(:user, email: 'kevinhughes27@gmail.com')
    assert user.staff?
  end

  test "sam is staff" do
    user = FactoryGirl.build(:user, email: 'samcluthe@gmail.com')
    assert user.staff?
  end

  test "bob is not staff" do
    user = FactoryGirl.build(:user)
    refute user.staff?
  end
end

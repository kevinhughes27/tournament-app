require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "kevin is staff" do
    user = FactoryBot.build(:user, email: 'kevinhughes27@gmail.com')
    assert user.staff?
  end

  test "sam is staff" do
    user = FactoryBot.build(:user, email: 'samcluthe@gmail.com')
    assert user.staff?
  end

  test "bob is not staff" do
    user = FactoryBot.build(:user)
    refute user.staff?
  end
end

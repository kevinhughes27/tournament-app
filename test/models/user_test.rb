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

  test "is_tournament_user? is true when the user belongs to the tournament" do
    user = FactoryBot.create(:user)
    tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:tournament_user, user: user, tournament: tournament)

    assert user.is_tournament_user?(tournament)
  end

  test "is_tournament_user? is false when the user doesn't belong to the tournament" do
    user = FactoryBot.create(:user)
    tournament = FactoryBot.create(:tournament)

    refute user.is_tournament_user?(tournament)
  end
end

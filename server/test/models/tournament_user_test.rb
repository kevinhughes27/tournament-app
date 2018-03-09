require 'test_helper'

class TournamentUserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, tournament: @tournament, user: @user)
  end

  test "tournament_users are unique" do
    assert @tournament.users.include? @user

    tournament_user = TournamentUser.new(user: @user, tournament: @tournament)
    refute tournament_user.save
    assert_equal ['has already been taken'], tournament_user.errors[:user]
  end

  test "limited number of users per tournament" do
    new_user = FactoryGirl.build(:user)

    stub_constant(TournamentUser, :LIMIT, 1) do
      tournament_user = @tournament.tournament_users.build(user: new_user)
      refute tournament_user.valid?
      assert_equal ['Maximum of 1 users exceeded'], tournament_user.errors[:base]
    end
  end

  test "limit is defined" do
    assert_equal 32, TournamentUser::LIMIT
  end
end

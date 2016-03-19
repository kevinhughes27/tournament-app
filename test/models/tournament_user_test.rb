require 'test_helper'

class TournamentUserTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
  end

  test "tournament_users are unique" do
    user = users(:kevin)
    tournament = tournaments(:noborders)

    assert tournament.users.include? user

    tournament_user = TournamentUser.new(user: user, tournament: tournament)
    refute tournament_user.save
    assert_equal ['has already been taken'], tournament_user.errors[:user]
  end

  test "limited number of users per tournament" do
    stub_constant(TournamentUser, :LIMIT, 1) do
      user = @tournament.tournament_users.build(user: users(:sam))
      refute user.valid?
      assert_equal ['Maximum of 1 users exceeded'], user.errors[:base]
    end
  end

  test "limit is define" do
    assert_equal 32, TournamentUser::LIMIT
  end
end

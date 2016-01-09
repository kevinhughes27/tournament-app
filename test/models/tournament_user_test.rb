require 'test_helper'

class TournamentUserTest < ActiveSupport::TestCase

  test "tournament_users are unique" do
    user = users(:kevin)
    tournament = tournaments(:noborders)

    assert tournament.users.include? user

    tournament_user = TournamentUser.new(user: user, tournament: tournament)
    refute tournament_user.save
    assert_equal ['has already been taken'], tournament_user.errors[:user]
  end

end

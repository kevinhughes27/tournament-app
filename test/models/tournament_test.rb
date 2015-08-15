require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  test "tournament requires a name" do
    tournament = Tournament.new()
    refute tournament.valid?
    assert_equal ["can't be blank"], tournament.errors[:name]
  end

  test "tournament requires a handle" do
    tournament = Tournament.new(name: 'No Borders')
    refute tournament.valid?
    assert_equal ["can't be blank", 'is invalid'], tournament.errors[:handle]
  end

  test "tournament requires a time cap" do
    tournament = Tournament.new(name: 'No Borders', handle: 'no-borders')
    refute tournament.valid?
    assert_equal ["can't be blank", "is not a number"], tournament.errors[:time_cap]
  end

  test "deleting a tournament deletes all its data" do
    tournament = tournaments(:noborders)
    tournament.destroy

    assert Map.where(tournament: tournament).empty?
    assert Field.where(tournament: tournament).empty?
    assert Team.where(tournament: tournament).empty?
    assert Bracket.where(tournament: tournament).empty?
    assert Game.where(tournament: tournament).empty?
    assert ScoreReport.where(tournament: tournament).empty?
  end
end

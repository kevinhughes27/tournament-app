require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
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

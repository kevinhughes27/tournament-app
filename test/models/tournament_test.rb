require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  test "tournament requires a name" do
    tournament = Tournament.new
    refute tournament.valid?
    assert_equal ["can't be blank"], tournament.errors[:name]
  end

  test "tournament name must be unique" do
    FactoryGirl.create(:tournament, name: 'No Borders')
    tournament = Tournament.new(name: 'No Borders', handle: 'new-handle')
    refute tournament.save
    assert_equal ["has already been taken"], tournament.errors[:name]
  end

  test "tournament requires a handle" do
    tournament = Tournament.new(name: 'No Borders')
    refute tournament.valid?
    assert_equal ["can't be blank", 'is invalid'], tournament.errors[:handle]
  end

  test "tournament handle must be unique" do
    FactoryGirl.create(:tournament, handle: 'no-borders')
    tournament = Tournament.new(name: 'New Tournament', handle: 'no-borders')
    refute tournament.save
    assert_equal ["has already been taken"], tournament.errors[:handle]
  end

  test "www is invalid handle" do
    tournament = Tournament.new(name: 'New Tournament', handle: 'www')
    refute tournament.save
    assert_equal ["is reserved"], tournament.errors[:handle]
  end

  test "handle is downcased" do
    tournament = Tournament.new(name: 'New Tournament', handle: 'New-Tournament')
    assert tournament.save
    assert_equal "new-tournament", tournament.handle
  end

  test "tournament requires at least one tournament user" do
    tournament = FactoryGirl.create(:tournament)
    refute tournament.valid?
    assert_equal ["can't be blank"], tournament.errors[:tournament_users]
  end

  test "deleting a tournament deletes all its data" do
    tournament = FactoryGirl.create(:tournament)
    tournament.destroy

    assert Map.where(tournament: tournament).empty?
    assert Field.where(tournament: tournament).empty?
    assert Team.where(tournament: tournament).empty?
    assert Division.where(tournament: tournament).empty?
    assert Game.where(tournament: tournament).empty?
    assert ScoreReport.where(tournament: tournament).empty?
  end
end

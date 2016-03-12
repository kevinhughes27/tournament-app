require 'test_helper'

class BracketSimulationTest < ActiveSupport::TestCase
  attr_reader :division, :tournament

  setup do
    @tournament = tournaments(:blank_slate_tournament)
  end

  Bracket.all.each do |bracket|
    test "create a division with bracket_type: #{bracket.name}" do
      @division = new_division(bracket.name)
      assert division
    end
  end

  Bracket.all.each do |bracket|
    test "seed a division with bracket_type: #{bracket.name}" do
      @division = new_division(bracket.name)
      create_teams
      division.seed
    end
  end

  Bracket.all.each do |bracket|
    test "play a division with bracket_type: #{bracket.name}" do
      @division = new_division(bracket.name)
      create_teams
      division.seed
      play_games
      assert_winner
    end
  end

  private

  def new_division(type)
    Division.create!(tournament: tournament, name: 'New Division', bracket_type: type)
  end

  def create_teams
    n = division.bracket.num_teams
    n.times do |idx|
      create_team_with_retry(idx+1)
    end
  end

  def create_team_with_retry(seed)
    3.times do
      begin
        create_team(seed)
        break
      rescue ActiveRecord::RecordInvalid
      end
    end
  end

  def create_team(seed)
    Team.create!(
      name: Faker::Team.name,
      tournament_id: tournament.id,
      division_id: division.id,
      seed: seed
    )
  end

  # loop until games are done
  # while loop since some games fetched won't be able
  # to be played depending on the order. Note that
  # update_score is safe and won't score games with
  # no teams.
  def play_games
    Timeout::timeout(5) do
      while games_to_be_played.present? do
        games_to_be_played.each do |game|
          game.update_score(*ScoreGenerator.generate)
        end
      end
    end
  rescue Timeout::Error

  end

  def games_to_be_played
    division.games.where(score_confirmed: false)
  end

  def assert_winner
    first_uid = division.bracket.game_uid_for_place('1st')
    game = division.games.find_by(bracket_uid: first_uid)
    assert game.winner
  end
end

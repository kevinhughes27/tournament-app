require 'test_helper'

class BracketSimulationTest < ActiveSupport::TestCase
  attr_reader :division, :tournament
  MAX_SIMULATION_TIME = 5

  setup do
    @tournament = tournaments(:blank_slate_tournament)
  end

  Bracket.all.each do |bracket|
    test "play a division with bracket_type: #{bracket.handle}" do
      @division = new_division(bracket.handle)
      assert division

      create_teams
      division.seed

      play_games

      assert_winner
      assert_places
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
    Timeout::timeout(MAX_SIMULATION_TIME) do
      while games_to_be_played.present? do
        games_to_be_played.each do |game|
          play_game(game)
        end
      end
    end
  rescue Timeout::Error
    puts "Simulation took too long"
  end

  def play_game(game)
    score = ScoreGenerator.generate
    Games::UpdateScoreJob.perform_now(
      game: game,
      home_score: score[0],
      away_score: score[1]
    )
  end

  def games_to_be_played
    division.games.where(score_confirmed: false)
  end

  def assert_winner
    place = division.places.find_by(position: 1)
    assert place.team
  end

  def assert_places
    division.places.each do |place|
      assert place.team, "place #{place.position} missing team"
    end

    division.teams.each do |team|
      assert Place.find_by(division: division, team: team), "team missing place, games_uids: #{games_uids_for_team(division, team)}"
    end
  end

  def games_uids_for_team(division, team)
    game_uids = []
    game_uids << Game.where(division: division, home: team).pluck(:bracket_uid, :pool)
    game_uids << Game.where(division: division, away: team).pluck(:bracket_uid, :pool)
    game_uids.flatten.compact.uniq
  end
end

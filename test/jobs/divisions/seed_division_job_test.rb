require 'test_helper'

module Divisions
  class SeedDivisionJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @teams = @tournament.teams.order(:seed)
    end

    test "initializes the first round" do
      division = new_division('single_elimination_8')
      @teams.update_all(division_id: division.id)

      SeedDivisionJob.perform_now(division: division, round: 1)

      @teams.sort_by{ |t| t.seed }
      games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])

      games.each do |game|
        assert_equal game.home, @teams[game.home_prereq_uid.to_i - 1]
        assert_equal game.away, @teams[game.away_prereq_uid.to_i - 1]
      end
    end

    test "raises if any games are invalid for a seed round" do
      division = new_division('single_elimination_8')
      @teams.update_all(division_id: division.id)

      assert_raises Division::InvalidSeedRound do
        SeedDivisionJob.perform_now(division: division, round: 2)
      end
    end

    test "resets any games past the seed round" do
      division = new_division('single_elimination_8')
      @teams.update_all(division_id: division.id)

      SeedDivisionJob.perform_now(division: division, round: 1)

      round1_games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])
      round2_games = division.games.where(bracket_uid: ['s1', 's2', 'c3', 'c4'])

      round1_games.each do |game|
        game.update_score(15,13)
      end

      assert = round2_games.all?{ |g| g.teams_present? }
      SeedDivisionJob.perform_now(division: division, round: 1)
      assert = round2_games.all?{ |g| not g.teams_present? }
    end

    test "round robin 5" do
      division = new_division('round_robin_5')
      @teams[5..-1].map(&:destroy)
      @teams.reload
      @teams.update_all(division_id: division.id)

      SeedDivisionJob.perform_now(division: division, round: 1)

      game = division.games.find_by(bracket_uid: 'rr3')
      assert_nil game.home
      assert_equal @teams.first, game.away
    end

    private

    def new_division(type)
      perform_enqueued_jobs do
        division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
      end
    end
  end
end

module Divisions
  class ResetRoundJob < ActiveJob::Base
    queue_as :default

    def perform(division:, round:)
      game_uids = division.bracket.game_uids_past_round(round)
      games = Game.where(division_id: division.id, bracket_uid: game_uids)

      games.each do |game|
        game.home = nil
        game.away = nil
        game.home_score = nil
        game.away_score = nil
        game.score_confirmed = false
        game.save!
      end
    end
  end
end

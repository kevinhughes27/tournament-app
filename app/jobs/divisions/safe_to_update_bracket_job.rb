module Divisions
  class SafeToUpdateBracketJob < ApplicationJob
    queue_as :default

    attr_reader :division, :games

    GAMES_SCHEDULE_MESSAGE = 'This division has games that have been scheduled. Changing the bracket' \
                             ' will reset those games. Are you sure this is what you want to do?'

    GAMES_PLAYED_MESSAGE = 'This division has games that have been scored. Changing the bracket' \
                           ' will reset those games. Are you sure this is what you want to do?'

    def perform(division:)
      @division = division
      @games = division.games

      if games_scheduled?
        return false, GAMES_SCHEDULE_MESSAGE
      elsif games_played?
        return false, GAMES_PLAYED_MESSAGE
      else
        return true
      end
    end

    private

    def games_played?
      games.where(score_confirmed: true).exists?
    end

    def games_scheduled?
      games.where.not(field_id: nil).exists?
    end
  end
end

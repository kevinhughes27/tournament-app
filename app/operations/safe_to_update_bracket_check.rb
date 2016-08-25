class SafeToUpdateBracketCheck < ApplicationOperation
  processes :division
  property :division, accepts: Division, required: true

  GAMES_SCHEDULE_MESSAGE = 'This division has games that have been scheduled. Changing the bracket' \
                           ' might reset some of those games. Are you sure this is what you want to do?'

  GAMES_PLAYED_MESSAGE = 'This division has games that have been scored. Changing the bracket' \
                         ' will reset those games. Are you sure this is what you want to do?'

  def execute
    halt GAMES_SCHEDULE_MESSAGE if games_scheduled?
    halt GAMES_PLAYED_MESSAGE if games_played?
  end

  private

  def games
    @games ||= division.games
  end

  def games_played?
    games.where(score_confirmed: true).exists?
  end

  def games_scheduled?
    games.where.not(field_id: nil).exists?
  end
end

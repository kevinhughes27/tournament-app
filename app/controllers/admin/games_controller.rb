class Admin::GamesController < AdminController
  def index
    @games = current_tournament.games.includes(
      :home,
      :away,
      :division,
      :score_disputes,
      score_reports: [:team]
    )
  end

  def update
    input = params_to_input(update_params, params, 'game_id')

    result = execute_graphql(
      'gameUpdateScore',
      'GameUpdateScoreInput',
      input,
      "{
         success,
         errors
       }"
    )

    if result['success']
      head :ok
    else
      render json: { error: result['errors'].first }, status: :unprocessable_entity
    end
  end

  private

  def update_params
    params.slice(:home_score, :away_score)
  end
end

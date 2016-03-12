class AppController < ApplicationController
  before_action :load_tournament
  layout 'app'

  def show
    @map = @tournament.map
    @fields = @tournament.fields.sort_by{|f| f.name.gsub(/\D/, '').to_i }
    @teams = @tournament.teams
    @games = @tournament.games
               .assigned
               .with_teams
               .includes(:home, :away, :field)

    render :show
  end

  def score_submit
    ScoreReport.create!(score_report_params)
    render json: true
  end

  private

  def load_tournament
    @tournament = tournament_scope.find(request.subdomain)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def tournament_scope
    Tournament.friendly
  end

  def score_report_params
    @score_report_params ||= params.permit(
      :tournament_id,
      :game_id,
      :team_id,
      :submitter_fingerprint,
      :team_score,
      :opponent_score,
      :rules_knowledge,
      :fouls,
      :fairness,
      :attitude,
      :communication,
      :comments,
    )

    @score_report_params[:tournament_id] = @tournament.id
    @score_report_params
  end

end

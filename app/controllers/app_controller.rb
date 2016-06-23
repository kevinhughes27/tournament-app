class AppController < ApplicationController
  include LoadTournament

  before_action :set_tournament_timezone

  layout 'app'

  def show
    @map = @tournament.map
    @fields = @tournament.fields.sort_by{|f| f.name.gsub(/\D/, '').to_i }
    @teams = @tournament.teams
    @games = @tournament.games
               .assigned
               .with_teams
               .includes(:home, :away, :field, :division)

    render :show
  end

  private

  # this can still be overridden by the user's timezone cookie
  def set_tournament_timezone
    Time.zone = @tournament.timezone
  end
end

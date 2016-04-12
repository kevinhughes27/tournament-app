class Internal::TournamentsController < InternalController
  def index
    @tournaments = Tournament.all.includes(:tournament_users, :users)
  end
end

class Internal::TournamentsController < InternalController
  PER_PAGE = 25

  def index
    @tournaments = Tournament.all
                    .includes(:tournament_users, :users)
                    .page(params[:page])
                    .per(PER_PAGE)
                    .order(created_at: :desc)
  end
end

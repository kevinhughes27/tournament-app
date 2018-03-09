class Internal::TournamentsController < InternalController
  PER_PAGE = 25

  def index
    @tournaments = default_scope

    if params[:search]
      @tournaments = @tournaments.where("handle LIKE ?", "%#{params[:search]}%")
    end
  end

  private

  def default_scope
    Tournament.includes(:tournament_users, :users)
      .page(params[:page])
      .per(PER_PAGE)
      .order(created_at: :desc)
  end
end

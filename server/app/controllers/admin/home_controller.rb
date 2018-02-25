class Admin::HomeController < AdminController
  def show
    @games_scheduled = @tournament.games.where.not(field_id: nil).count
  end
end

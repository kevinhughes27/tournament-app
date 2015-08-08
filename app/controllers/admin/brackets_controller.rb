class Admin::BracketsController < AdminController

  def index
    @teams = @tournament.teams
  end

end

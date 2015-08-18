class Admin::SeedingController < AdminController

  def index
    @teams = @tournament.teams
  end

  def update
    teams = Team.where( id: params[:team_ids] )

    teams.each_with_index do |team, idx|
      team.update_attribute( :seed, params[:seeds][idx] )
    end

    @teams = @tournament.teams
    render :index
  end
end

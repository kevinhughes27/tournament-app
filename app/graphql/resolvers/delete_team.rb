class Resolvers::DeleteTeam < Resolvers::BaseResolver
  TEAM_DELETE_NOT_ALLOWED = """There are games scheduled for this team.\
 In order to delete this team you need to delete the\
 DIVISION_NAME division first."""

  def call(inputs, ctx)
    @team = ctx[:tournament].teams.find(inputs[:id])

    if !allow_delete?
      {
        team: @team,
        success: false,
        message: TEAM_DELETE_NOT_ALLOWED.gsub('DIVISION_NAME', @team.division.name)
      }
    elsif @team.destroy
      {
        team: @team,
        success: true,
        message: 'Team deleted'
      }
    else
      {
        team: @team,
        success: false,
        message: 'Delete failed'
      }
    end
  end

  def allow_delete?
    !Game.where(tournament_id: @team.tournament_id, home_id: @team.id).exists? &&
    !Game.where(tournament_id: @team.tournament_id, away_id: @team.id).exists?
  end
end

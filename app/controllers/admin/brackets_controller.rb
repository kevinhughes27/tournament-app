class Admin::BracketsController < AdminController
  TAB_KEY = 'bracketsTab'

  def index
    @teams = @tournament.teams
    @brackets = @tournament.brackets
    ensure_bracket_per_division
  end

  def create
    @bracket = Bracket.create(bracket_params)
    @num_teams = Team.where(division: @bracket.division).count

    if @bracket.persisted?
      render partial: 'bracket', locals: {num_teams: @num_teams, bracket: @bracket}
    else
      render json: { errors: @bracket.errors.full_messages }, status: :unprocessible_entity
    end
  end

  def update
    @bracket = Bracket.find(params[:id])
    @num_teams = Team.where(division: @bracket.division).count

    if @bracket.update_attributes(bracket_params)
      render partial: 'bracket', locals: {num_teams: @num_teams, bracket: @bracket}
    else
      render json: { errors: @bracket.errors.full_messages }, status: :unprocessible_entity
    end
  end

  def update_seeds
    @teams = Team.where( id: params[:team_ids] )

    @teams.each_with_index do |team, idx|
      team.update_attribute( :seed, params[:seeds][idx] )
    end

    render partial: 'seeding', locals: {division: @teams[0].division, teams: @teams}
  end

  def seed
    @bracket = Bracket.find(params[:id])
    @teams = @tournament.teams.where(division: @bracket.division).order(:seed)

    begin
      seeds = @teams.pluck(:seed).sort
      seeds.each_with_index do |seed, idx|
        raise Bracket::AmbiguousSeedList.new('ambiguous seed list') unless seed == (idx+1)
      end

      @bracket.seed(@teams)
      render partial: 'bracket', locals: {num_teams: @teams.size, bracket: @bracket}

    rescue => error
      render json: { error: error.message }, status: :unprocessible_entity
    end
  end

  private

  def ensure_bracket_per_division
    @brackets = @brackets.to_a
    @teams.group_by{ |t| t.division }.each do |division, teams|
      unless @brackets.detect{ |b| b.division == division}
        @brackets << Bracket.new(tournament: @tournament, division: division)
      end
    end
  end

  def bracket_params
    @bracket_params ||= params.require(:bracket).permit(
      :tournament_id,
      :division,
      :bracket_type
    )
  end

end

class Admin::BracketsController < AdminController

  def index
    @teams = @tournament.teams
    @brackets = @tournament.brackets
    ensure_bracket_per_division
  end

  def create
    @bracket = Bracket.create!(bracket_params)
    render partial: 'form', locals: {bracket: @bracket}
  end

  def update
    @bracket = Bracket.find(params[:id])
    @bracket.update_attributes(bracket_params)
    render partial: 'form', locals: {bracket: @bracket}
  end

  def seed
    @bracket = Bracket.find(params[:id])
    @teams = @tournament.teams.where(division: @bracket.division).order(:seed)

    begin
      @bracket.seed(@teams)
      head :ok
    rescue => e
      head :unprocessible_entity
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

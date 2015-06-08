class TeamsController < ApplicationController
  before_action :load_tournament, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams
  def index
    @teams = Team.all
  end

  # GET /teams/1
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to @team, notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  def import
    Team.import(params[:file], @tournament.id)
    redirect_to tournament_path(params[:tournament_id]), notice: "Teams imported."
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to tournament_path(params[:tournament_id]), notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to tournament_path(params[:tournament_id]), notice: 'Team was successfully destroyed.'
  end

  private

  def load_tournament
    if params[:tournament_id]
      @tournament = Tournament.friendly.find(params[:tournament_id])
    else
      @tournament = Tournament.friendly.find(params[:id])
    end
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :email, :sms, :twitter, :division)
  end
end

class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :import_team, :set_tournament]

  # GET /tournaments
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  def show
    @teams = Team.where(tournament_id: @tournament)
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new(
      lat: 56.0,
      long: -96.0,
      zoom: 4
    )
  end

  # POST /tournaments
  def create
    @tournament = Tournament.new(tournament_params)

    if @tournament.save
      redirect_to @tournament, notice: 'Tournament was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tournaments/1
  def update
    if @tournament.update(tournament_params)
      redirect_to @tournament, notice: 'Tournament was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tournaments/1
  def destroy
    @tournament.destroy
    redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.'
  end

  def import_team
    Team.import(params[:file], @tournament.id)
    redirect_to tournament_path(params[:tournament_id]), notice: "Teams imported."
  end

  private

  def set_tournament
    if params[:tournament_id]
      @tournament = Tournament.friendly.find(params[:tournament_id])
    else
      @tournament = Tournament.friendly.find(params[:id])
    end
  end

  def tournament_params
    params.require(:tournament).permit(
      :name,
      :description,
      :lat,
      :long,
      :zoom
    )
  end
end

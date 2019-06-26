class FilesController < ApplicationController
  include TournamentController

  before_action :authenticate_user
  before_action :authenticate_tournament_user!

  def fields_csv
    @tournament = current_tournament

    @fields = @tournament.fields.sort_by{ |f| f.name.gsub(/\D/, '').to_i }

    csv = FieldCsvExport.perform(@fields)

    respond_to do |format|
      format.csv { send_data csv, filename: 'fields.csv' }
    end
  end

  def score_reports_csv
    @tournament = current_tournament

    @reports = @tournament.score_reports.includes(game: [:home, :away, :division])

    csv = ReportsCsvExport.perform(@reports)

    respond_to do |format|
      format.csv { send_data csv, filename: 'reports.csv' }
    end
  end

  def schedule_pdf
    @tournament = current_tournament

    @fields = @tournament.fields.sort_by{ |f| f.name.gsub(/\D/, '').to_i }

    @divisions = @tournament.divisions.includes(
      :teams,
      games: [
        :home,
        :away
      ]
    )

    @games = @tournament.games.includes(
      :division,
      :home,
      :away,
      :score_reports,
      :score_disputes
    ).order(:division_id, :start_time)

    respond_to do |format|
      format.pdf { render pdf: 'schedule', orientation: 'Landscape' }
    end
  end

  private

  def authenticate_user
    head 401  unless current_user
  end

  def authenticate_tournament_user!
    return if current_user.staff?
    head 401 unless current_user.is_tournament_user?(@tournament)
  end

  def current_user
    @current_user ||= begin
      Knock::AuthToken.new(token: token).entity_for(User)
    rescue Knock.not_found_exception_class, JWT::DecodeError
      nil
    end
  end

  def token
    token = cookies['jwt']
  end
end

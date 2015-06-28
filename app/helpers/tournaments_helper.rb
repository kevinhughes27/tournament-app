module TournamentsHelper
  def sidebar_brand(tournament)
    if tournament.name.present?
      tournament.name
    else
      'Tournament App'
    end
  end
end

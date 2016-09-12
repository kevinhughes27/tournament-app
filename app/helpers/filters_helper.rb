module FiltersHelper
  def division_filters(tournament)
    tournament.divisions.map do |division|
      { text: "#{division.name} Division", key: 'division', value: division.name }
    end
  end

  def pool_filters(tournament)
    tournament.games.pluck(:pool).uniq.map do |pool_uid|
      { text: "Pool #{pool_uid}", key: 'pool', value: pool_uid, hidden: true }
    end
  end
end

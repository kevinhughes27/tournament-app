module FiltersHelper
  def division_filters(tournament)
    tournament.divisions.map do |division|
      {text: "#{division.name} Division", key: 'division', value: division.name}
    end
  end
end

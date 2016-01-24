module FiltersHelper
  def division_filters(collection)
    divisions = collection.map(&:division).uniq

    divisions.map do |division|
      {text: "#{division} Division", key: 'division', value: division}
    end
  end
end

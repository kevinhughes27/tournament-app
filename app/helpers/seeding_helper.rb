module SeedingHelper
  def division_html_id(division)
    division.gsub(/\s+/, '')
  end
end

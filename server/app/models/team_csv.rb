require 'csv'

class TeamCsv
  def self.sample
    CSV.generate do |csv|
      csv << ['Name', 'Email', 'Phone', 'Division', 'Seed']
      csv << ['Swift', 'swift@gmail.com', '613-979-4997', 'Open', '1']
    end
  end
end

class TeamCsvImporter
  attr_reader :tournament, :file, :ignore

  def initialize(tournament, file, ignore)
    @tournament = tournament
    @file = file
    @ignore = ignore
  end

  def run!
    teams = @tournament.teams

    rowNum = 1
    Team.transaction do
      CSV.foreach(file, headers: true, :header_converters => lambda { |h| h.try(:downcase).strip }) do |row|
        rowNum += 1
        attributes = row.to_hash.with_indifferent_access
        attributes = csv_params(attributes)

        if attributes[:division]
          if division = Division.find_by(tournament_id: @tournament.id, name: attributes[:division])
            attributes[:division] = division
          else
            attributes.delete(:division)
          end
        end

        if team = teams.detect{ |t| t.name == attributes[:name] }
          next if ignore
          team.update!(attributes)
        else
          @tournament.teams.create!(attributes)
        end
      end
    end
  end

  private

  def csv_params(attributes)
    attributes.slice(
      :name,
      :email,
      :phone,
      :division,
      :seed
    )
  end
end

require 'csv'

class TeamCsvImport < ApplicationOperation
  processes :tournament, :file, :ignore

  property :tournament, accepts: Tournament, required: true
  property :file, required: true
  property :ignore, accepts: [true, false], default: false

  attr_reader :row_num

  def execute
    @row_num = 1
    Team.transaction do
      CSV.foreach(file, headers: true, :header_converters => lambda { |h| h.try(:downcase).strip }) do |row|
        @row_num += 1
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
  rescue StandardError => e
    fail e.message
  end

  private

  def teams
    @teams ||= tournament.teams
  end

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

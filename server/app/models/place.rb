class Place < ApplicationRecord
  belongs_to :tournament
  belongs_to :division
  belongs_to :team

  validates_presence_of :tournament
  validates_presence_of :division
  validates_presence_of :prereq
  validates_presence_of :position

  def self.from_template(tournament_id:, division_id:, template_place:)
    new(
      template_place.merge(
        tournament_id: tournament_id,
        division_id: division_id
      )
    )
  end

  def place
    "#{position}#{ordinal(position)}"
  end
end

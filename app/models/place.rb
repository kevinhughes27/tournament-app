class Place < ApplicationRecord
  belongs_to :tournament
  belongs_to :division
  belongs_to :team

  def place
    "#{position}#{ordinal(position)}"
  end
end

class Place < ApplicationRecord
  belongs_to :tournament
  belongs_to :division
  belongs_to :team

  validates_presence_of :tournament
  validates_presence_of :division
  validates_presence_of :prereq_uid
  validates_presence_of :position

  def place
    "#{position}#{ordinal(position)}"
  end
end

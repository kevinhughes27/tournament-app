class Place < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :division
  belongs_to :team
  validate :has_prereq

  def place
    "#{position}#{ordinal(position)}"
  end

  private

  def has_prereq
    self.prereq_uid.present? || self.prereq_logic.present?
  end
end

module Limits
  extend ActiveSupport::Concern

  included do
    validate :under_limit
  end

  def under_limit
    if self.class.where(tournament_id: self.tournament_id).count >= limit_constant
      self.errors.add(:base, message)
    end
  end

  def limit_constant
    self.class::LIMIT
  rescue
    raise "LIMIT constant not defined for #{self.class}"
  end

  def message
    "Maximum of #{limit_constant} #{model_name.plural} exceeded"
  end
end

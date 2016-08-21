class FinishPoolJob < ApplicationJob
  attr_reader :division, :pool

  def perform(division:, pool_uid:)
    pool = Pool.new(division, pool_uid)
    FinishPool.perform(pool)
  end
end

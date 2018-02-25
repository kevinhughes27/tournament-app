class BackfillPoolWinsPoints < ActiveRecord::Migration[5.0]
  def change
    Division.find_each do |division|
      division.pools.each do |pool|
        next unless pool.finished?
        pool.clear_results
        pool.persist_results
      end
    end
  end
end

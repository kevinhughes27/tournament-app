module Schedulable
  extend ActiveSupport::Concern

  included do
    scope :scheduled, -> { where.not(
      field_id: nil,
      start_time: nil,
      end_time: nil
    )}

    with_options if: :scheduled? do |game|
      game.validates :start_time, presence: true, date: true
      game.validates :end_time,  presence: true, date: true
      game.validates :field, presence: true
      game.validates_associated :field
    end
  end

  def schedule(field_id, start_time, end_time)
    assign_attributes(field_id: field_id, start_time: start_time, end_time: end_time)
  end

  def unschedule!
    update!(field_id: nil, start_time: nil, end_time: nil)
  end

  def scheduled?
    !!(field_id || start_time || end_time)
  end

  def played?
    return false unless scheduled?
    Time.now > end_time
  end

  def length
    return nil unless scheduled?
    ((end_time - start_time) / 60).to_i
  end

  def playing_time_range_string
    formatted_start = start_time.strftime("%l:%M %p")
    formatted_end = end_time.strftime("%l:%M %p")
    "#{formatted_start} - #{formatted_end}"
  end
end

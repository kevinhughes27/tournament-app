module ScheduleHelper
  def time_for_datetimepicker(time)
    if time
      time.to_formatted_s(:datetimepicker)
    else
      ""
    end
  end
end

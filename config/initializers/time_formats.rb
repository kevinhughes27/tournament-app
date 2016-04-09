Time::DATE_FORMATS[:datetimepicker]  = ->(time) { time.strftime("%m/%d/%Y %l:%M %p") }
Time::DATE_FORMATS[:timeonly]  = ->(time) { time.strftime("%l:%M %p") }

Time::DATE_FORMATS[:schedule]  = ->(time) { time.strftime("%m/%d/%Y %l:%M %p") }
Time::DATE_FORMATS[:timeonly]  = ->(time) { time.strftime("%l:%M %p") }

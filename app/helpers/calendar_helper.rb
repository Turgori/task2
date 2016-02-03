module CalendarHelper
  def calendar_day(date = Date.today)
    l date, format: :day
  end

  def calendar_day_full(date = Date.today)
    l date, format: :day_full
  end

  def calendar_title(date)
    l date, format: :month
  end

  def event_date(date)
    l date, format: :rus_format
  end
end

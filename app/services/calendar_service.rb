class CalendarService
  def initialize(options = {})
    @options = options
    @options[:date] ||= Time.now

    @events = []
    @date = @options[:date].to_date
  end

  def dates
    {
      date: @date,
      previous_month: @date.prev_month,
      next_month: @date.next_month
    }
  end

  def sort_events(current_user_id)
    load_events_by_month(current_user_id, @options[:all])
    sorted_events = default_calendar

    @events.each do |event|
      dates = {}

      case event.event_type.to_sym
        when :daily
          dates = load_daily_events(event)
        when :weekly
          dates = load_weekly_events(event)
          dates[event.date.day] = event
        else
          dates[event.date.day] = event
      end

      sorted_events.merge!(dates) do |_, oldval, newval|
        oldval << newval
      end
    end

    sorted_events
  end

  private

  def beginning_of_month
    @date.beginning_of_month
  end

  def end_of_month
    @date.end_of_month
  end

  def load_events_by_month(current_user_id, all = false)
    event = if all == "true"
      Event.visible(current_user_id)
    else
      Event.by_user(current_user_id)
    end

    events_before_end = event.where("date <= ?", end_of_month)

    Event.simple_types.each do |type|
      @events += events_before_end.public_send(type.to_s)
    end

    @events += event.once(beginning_of_month, end_of_month)
    @events += event.yearly(@date.month)
  end

  def default_calendar
    (beginning_of_month..end_of_month).each_with_object({}) { |date, hash| hash[date.day] = [] }
  end

  def load_daily_events(event)
    start_day = (event.date > beginning_of_month) ? event.date : beginning_of_month
    (start_day..end_of_month).each_with_object({}) { |date, hash| hash[date.day] = event }
  end

  def first_weekday_of_month(cwday)
    diff = cwday - beginning_of_month.cwday
    diff += 7 if diff < 0

    beginning_of_month + diff
  end

  def load_weekly_events(event)
    dates = {}

    weekly_event_date = if event.date.month != @date.month
      first_weekday_of_month(event.date.cwday)
    else
      event.date
    end

    while weekly_event_date < end_of_month
      dates[weekly_event_date.day] = event
      weekly_event_date += 1.week
    end

    dates
  end
end

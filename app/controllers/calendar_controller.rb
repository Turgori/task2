class CalendarController < ApplicationController
  before_action :authenticate_user!

  def show
    calendar = CalendarService.new(calendar_params)
    @events = calendar.sort_events(current_user.id)
    @dates = calendar.dates

    # NOTE: need for month_calendar render
    params[:start_date] = @dates[:date]
  end

  private

  def calendar_params
    params.permit(:date, :start_date, :previous_month, :next_month, :all)
  end
end

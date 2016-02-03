class EventsController < ApplicationController
  before_action :authenticate_user!
  load_resource only: [:show, :edit, :destroy]
  authorize_resource

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      redirect_to @event
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to calendar_path(Date.today)
  end

  private

  def event_params
    params.require(:event).permit(:name, :date, :event_type, :private)
  end
end

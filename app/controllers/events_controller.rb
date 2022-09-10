class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, expect: %i[ show index ]
  before_action :set_event, only: [:show]
  before_action :set_current_user_event, only: %i[ edit update destroy ]

  def index
    @events = Event.all
  end

  def show
  end

  def new
    @event = current_user.events.build
  end

  def edit
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new
    end
  end

  def update
      if @event.update(event_params)
        redirect_to @event, notice: "Event was successfully updated."
      else
        render :edit
      end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    redirect_to events_path, notice: "Event was successfully destroyed."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def set_current_user_event
    @event = current_user.events.find(params[:id])
  end

  def event_params
    params.require(:subject, :description, :address, :datetime)
  end
end

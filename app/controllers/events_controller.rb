class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :set_event, only: %i[show edit update destroy]
  after_action :verify_authorized, only: %i[edit update destroy]

  def index
    @events = Event.all
  end

  def show
    begin
      authorize @event
    rescue Pundit::NotAuthorizedError
      if params[:pincode].present?
        flash.now[:alert] = t('activerecord.controllers.events.wrong_pincode')
      end
      render 'password_form'
    end
    @new_comment = @event.comments.build(params[:comment])
    @new_subscription = @event.subscriptions.build(params[:subscription])
    @new_photo = @event.photos.build(params[:photo])
  end

  def new
    @event = current_user.events.build
  end

  def edit
    authorize @event
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: t('activerecord.controllers.events.created')
    else
      flash.now[:alert] = t('activerecord.controllers.events.error')
      render :new
    end
  end

  def update
    authorize @event
    if @event.update(event_params)
      redirect_to @event, notice: t('activerecord.controllers.events.updated')
    else
      flash.now[:alert] = t('activerecord.controllers.events.error')
      render :edit
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    authorize @event
    @event.destroy

    redirect_to events_path, notice: t('activerecord.controllers.events.destroyed')
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :address, :datetime, :pincode)
  end
end

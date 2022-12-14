class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:create, :destroy]
  before_action :set_photo, only: [:destroy]

  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.save
      RecordNotificationJob.perform_later(@new_photo)
      redirect_to @event, notice: I18n.t('activerecord.controllers.photos.created')
    else
      flash.now[:alert] = t('activerecord.controllers.photos.error')
      render 'events/show'
    end
  end

  def destroy
    message = {notice: I18n.t('activerecord.controllers.photos.destroyed')}
    if current_user_can_edit?(@photo)
      @photo.destroy
    else
      message = {alert: I18n.t('activerecord.controllers.photos.error')}
    end

    redirect_to @event, message
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  # Получаем фотографию из базы стандартным методом find
  def set_photo
    @photo = @event.photos.find(params[:id])
  end

  # При создании новой фотографии мы получаем массив параметров photo
  # c единственным полем photo
  def photo_params
    params.fetch(:photo, {}).permit(:photo)
  end
end

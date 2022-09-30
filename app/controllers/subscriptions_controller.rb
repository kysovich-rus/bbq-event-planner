class SubscriptionsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_subscription, only: [:destroy]

  # POST /subscriptions or /subscriptions.json
  def create
    @new_subscription = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    if @new_subscription.save
      SubscriptionNotificationJob.perform_later(@new_subscription)
      redirect_to @event, notice: t('activerecord.controllers.subscriptions.created')
    else
      flash.now[:alert] = t('activerecord.controllers.subscriptions.error')
      render 'events/show'
    end
  end

  # DELETE /subscriptions/1 or /subscriptions/1.json
  def destroy
    message = {notice: t('activerecord.controllers.subscriptions.destroyed')}
    if current_user_can_edit?(@subscription)
      @subscription.destroy
    else
      message = {alert: t('activerecord.controllers.subscriptions.error')}
    end
    redirect_to @event, message
  end

  private

  def set_subscription
    @subscription = @event.subscriptions.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def subscription_params
    params.fetch(:subscription, {}).permit(:user_email, :user_name)
  end
end

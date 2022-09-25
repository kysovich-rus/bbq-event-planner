class CommentsController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]

  def new
    @comment = Comment.new
  end

  def create
    @new_comment = @event.comments.build(comment_params)
    @new_comment.user = current_user

    if check_captcha(@new_comment) && @new_comment.save
      notify_subscribers(@event, @new_comment)
      redirect_to @event, notice: t('activerecord.controllers.comments.created')
    else
      render 'events/show', alert: t('activerecord.controllers.comments.error')
    end
  end

  def destroy
    message = { notice: t('activerecord.controllers.comments.destroyed') }

    if current_user_can_edit?(@comment)
      @comment.destroy
    else
      message = { alert: t('activerecord.controllers.comments.error') }
    end

    redirect_to @event, message
  end

  private

  def check_captcha(model)
    current_user.present? || verify_recaptcha(model: model)
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :user_name)
  end

  def notify_subscribers (event, comment)
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email] - [comment.user&.email]).uniq

    all_emails.each do |email|
      EventMailer.comment(comment, email).deliver_now
    end
  end
end

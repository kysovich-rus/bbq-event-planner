class CommentsController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @new_comment = @event.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      notify_subscribers(@event, @new_comment)
      redirect_to @event, notice: t('activerecord.controllers.comments.created')
    else
      render 'events/show', alert: t('activerecord.controllers.comments.error')
    end
  end

  # DELETE /comments/1 or /comments/1.json
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

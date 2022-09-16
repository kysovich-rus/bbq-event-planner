class EventMailer < ApplicationMailer

  def subscription(subscription)
    @email = subscription.user_email || subscription.user&.email
    @name = subscription.user_name
    @event = subscription.event

    mail to: @event.user.email, subject: "Новая подписка на событие #{@event.title}"
  end

  def comment(comment, email)
    @comment = comment
    @event = comment.event

    mail to: email, subject: "Новый комментарий к событию #{@event.title} "
  end
end

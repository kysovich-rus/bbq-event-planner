class CommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment)
    event = comment.event
    notification_emails = (event&.subscriptions&.map(&:user_email) + [event.user.email]).uniq - [comment.user&.email]
    notification_emails.each do |mail|
      EventMailer.comment(comment, mail).deliver_now
    end
  end
end

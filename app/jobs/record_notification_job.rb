class RecordNotificationJob < ApplicationJob
  queue_as :default

  def perform(record)
    event = record.event
    notification_emails = (event&.subscriptions&.map(&:user_email) + [event.user.email]).uniq - [record.user&.email]
    EventMailer.photo(record, notification_emails).deliver_now if record.class == Photo
    EventMailer.comment(record, notification_emails).deliver_now if record.class == Comment
  end
end

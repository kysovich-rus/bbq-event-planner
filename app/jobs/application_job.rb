class ApplicationJob < ActiveJob::Base
  def notification_emails(record)
    event = record.event
    (event&.subscriptions&.map(&:user_email) + [event.user.email]).uniq - [record.first&.user&.email]
  end
end

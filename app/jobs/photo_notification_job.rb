class PhotoNotificationJob < ApplicationJob
  queue_as :default

  def perform(photo)
    event = photo.event
    notification_emails = (event&.subscriptions&.map(&:user_email) + [event.user.email]).uniq - [photo.user&.email]
    notification_emails.each do |email|
      EventMailer.photo(photo, email).deliver_now
    end
  end
end

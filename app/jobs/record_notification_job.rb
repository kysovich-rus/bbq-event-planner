class RecordNotificationJob < ApplicationJob
  queue_as :default

  def perform(record)
    notification_emails(record).each do |email|
      if record.first.class == Photo
        EventMailer.photos(record.first, email).deliver_later
      else
        EventMailer.comment(record.first, email).deliver_later
      end
    end
  end
end

class SignUpNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    UserMailer.registration(user).deliver_now
  end
end

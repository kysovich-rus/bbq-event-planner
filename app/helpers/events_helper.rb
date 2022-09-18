module EventsHelper
  def user_can_add_photo?(event)
    current_user == event.user || event.subscribers.include?(current_user)
  end
end

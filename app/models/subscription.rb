class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  before_validation :downcase_user_email

  validates :event, presence: true

  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true,
            format: { with: /\A[\w\-.]+@[\w\-.]+\z/},
            unless: -> { user.present? }

  validates :user, uniqueness: {scope: :event_id}, if: -> { user.present? }
  validates :user_email, uniqueness: {scope: :event_id}, unless: -> { user.present? }

  validate :event_authors_subscription
  validate :email_of_existing_user?

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  private

  def downcase_user_email
    user_email&.downcase!
  end

  def event_authors_subscription
    if event.user == user
      errors.add(:user, t('activerecord.controllers.subscriptions.error_author_is_subscribed'))
    end
  end

  def email_of_existing_user?
    if User.find_by(email:   user_email).present?
      errors.add(:user_email, I18n.t('activerecord.controllers.subscriptions.error_email_is_used'))
    end
  end


end

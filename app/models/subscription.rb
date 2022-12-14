class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  before_validation :downcase_user_email

  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, unless: -> { user.present? }
  validates :user_email, format: { with: /\A[\w\-.]+@[\w\-.]+\z/}, if: -> { user_email.present? }
  validates :user, uniqueness: {scope: :event_id}, if: -> { user.present? }
  validates :user_email, uniqueness: {scope: :event_id}, unless: -> { user.present? }

  validate :event_authors_subscription
  validate :email_of_existing_user, unless: -> { user.present? }

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user&.email
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
      errors.add(:user, t('activerecord.errors.models.subscription.author_is_subscribed'))
    end
  end

  def email_of_existing_user
    if User.find_by(email: user_email).present?
      errors.add(:user_email, I18n.t('activerecord.errors.models.subscription.email_already_taken'))
    end
  end
end

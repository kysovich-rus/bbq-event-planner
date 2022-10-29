require 'open-uri'

class User < ApplicationRecord
  before_validation :set_name, on: :create
  after_commit :link_subscriptions, on: :create
  after_create :send_notification
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :omniauthable, omniauth_providers: [:google_oauth2, :github, :vkontakte]

  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :photos, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [70, 70]
    attachable.variant :default, resize_to_fill: [200, 200]
  end

  validates :name, presence: true, length: {maximum: 64}
  validates :email, presence: true, length: {maximum: 255}
  validates :email, uniqueness: true
  validates :email, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/

  def self.from_oauth(response)
    email = response.info.email
    name = response.info.name
    provider = response.provider
    uid = response.uid
    user = User.where(email: email).first

    return user if user.present?

    where(uid: uid, provider: provider).first_or_create! do |user|
      user.uid = uid
      user.name = name
      user.email = email
      image_src = URI.parse(response.info.image).open
      user.avatar.attach(io: image_src, filename: 'avatar.png')

      user.password = Devise.friendly_token.first(16)
    end
  end

  private

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email)
                .update_all(user_id: self.id)
  end

  def set_name
    self.name = "Господин(жа) №#{rand(999)}" if self.name.nil?
  end

  def send_notification
    SignUpNotificationJob.perform_later(self)
  end
end

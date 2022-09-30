class User < ApplicationRecord
  before_validation :set_name, on: :create
  after_commit :link_subscriptions, on: :create
  after_create :send_notification
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  has_many :events
  has_many :comments, dependent: :destroy
  has_many :subscriptions
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [70, 70]
    attachable.variant :default, resize_to_fill: [200, 200]
  end

  validates :name, presence: true, length: {maximum: 35}
  validates :email, presence: true, length: {maximum: 255}
  validates :email, uniqueness: true
  validates :email, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/

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

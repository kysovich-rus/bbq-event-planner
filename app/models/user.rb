class User < ApplicationRecord
  before_validation :set_name, on: :create
  after_commit :link_subscriptions, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  has_many :events
  has_many :comments, dependent: :destroy
  has_many :subscriptions

  validates :name, presence: true, length: {maximum: 35}
  validates :email, presence: true, length: {maximum: 255}
  validates :email, uniqueness: true
  validates :email, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/
  validates :password, length: {minimum: 6}
  validate  :password_confirmed?

  def password_confirmed?
    unless password.present? && password == password_confirmation
      errors.add(:user, I18n.t('activerecord.errors.models.user.passwords_dont_match'))
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
end

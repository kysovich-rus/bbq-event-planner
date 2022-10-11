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
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [70, 70]
    attachable.variant :default, resize_to_fill: [200, 200]
  end

  validates :name, presence: true, length: {maximum: 35}
  validates :email, presence: true, length: {maximum: 255}
  validates :email, uniqueness: true
  validates :email, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/

  def self.oauth(params)
    # Достаём email из токена
    email = params[:email]
    name = params[:name]
    user = where(email: email).first

    # Возвращаем, если нашёлся
    return user if user.present?

    # Если не нашёлся, достаём провайдера, айдишник и урл
    provider = params[:provider]
    uid = params[:uid]
    url = params[:url]

    # Теперь ищем в базе запись по провайдеру и урлу
    # Если есть, то вернётся, если нет, то будет создана новая
    where(uid: uid, provider: provider).first_or_create! do |user|
      # Если создаём новую запись, прописываем email и пароль
      user.uid = uid
      user.url = url
      user.name = name
      user.email = email
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

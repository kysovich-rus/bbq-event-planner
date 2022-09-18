class Event < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  has_many :photos, dependent: :destroy

  validates :title, presence: true, length: {maximum: 255}
  validates :address, presence: true
  validates :datetime, presence: true

  def comment_count
    (comments.except(@new_comment)).count
  end

  def photo_count
    (photos.except(@new_photo)).count
  end

  def sub_count
    (subscriptions.except(@new_subscription) + [user]).uniq.count
  end

  def visitors
    (subscribers + [user]).uniq
  end

  def pincode_valid?(received_pincode)
    pincode == received_pincode
  end
end

class Photo < ApplicationRecord
  belongs_to :event
  belongs_to :user

  has_one_attached :photo do |attachable|
    attachable.variant :thumb, resize_to_fit: [75, 75]
    attachable.variant :medium, resize_to_fit: [300, 300]
  end

  scope :persisted, -> { where "id IS NOT NULL" }

  validates :user, presence: true
end

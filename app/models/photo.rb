class Photo < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :event, presence: true
  validates :user, presence: true

  has_one_attached :photo do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  validates :photo, presence: true, file_size: { less_than_or_equal_to: 2.megabytes },
            file_content_type: { allow: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] }

  scope :persisted, -> { where "id IS NOT NULL" }
end

class Theme < ApplicationRecord
  attachment :image

  validates :content, presence: true, length: { maximum: 120 }

  belongs_to :user
  has_many :answers
end

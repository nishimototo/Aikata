class Theme < ApplicationRecord
  attachment :image

  belongs_to :user
  has_many :answers
end

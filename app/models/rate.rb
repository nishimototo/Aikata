class Rate < ApplicationRecord
  validates :rate, presence: true, numericality: {
    less_than_or_equal_to: 3,
    greater_than_or_equal_to: 0,
  }

  belongs_to :user
  belongs_to :answer
end

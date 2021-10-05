class Room < ApplicationRecord
  has_many :user_rooms
  has_many :chats
  has_many :users, through: :user_rooms #追加
end

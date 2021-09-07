class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image


  validates :name, presence: true

  has_many :articles, dependent: :destroy
  has_many :themes, dependent: :destroy
  has_many :answers, dependent: :destroy

  def active_for_authentication?
    super && (self.is_deleted == false)
  end
end

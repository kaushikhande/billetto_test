class User < ApplicationRecord
  validates :clerk_user_id, presence: true

  has_many :votes, dependent: :destroy
end

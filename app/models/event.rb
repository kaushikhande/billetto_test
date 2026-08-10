class Event < ApplicationRecord
  validates :billetto_id, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  has_many :votes, dependent: :destroy
end

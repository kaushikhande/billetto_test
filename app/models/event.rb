class Event < ApplicationRecord
  validates :billetto_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end

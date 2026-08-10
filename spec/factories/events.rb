FactoryBot.define do
  factory :event do
    billetto_id { "billetto_#{SecureRandom.hex(4)}" }
    title { "Test Event" }
    start_date { 1.day.from_now }
    end_date { 2.days.from_now }
  end
end

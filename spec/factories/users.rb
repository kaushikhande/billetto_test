FactoryBot.define do
  factory :user do
    clerk_user_id { "user_#{SecureRandom.hex(4)}" }
    email { "#{SecureRandom.hex(4)}@example.com" }
    name { "Test User" }
  end
end

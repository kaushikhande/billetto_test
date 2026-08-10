require "rails_helper"

RSpec.describe Event, type: :model do
  subject(:event) do
    described_class.new(
      billetto_id: "123",
      title: "Test Event",
      start_date: 1.day.from_now,
      end_date: 2.days.from_now
    )
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:billetto_id) }
    it { is_expected.to validate_uniqueness_of(:billetto_id).case_insensitive }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
  end

  describe "associations" do
    it { is_expected.to have_many(:votes).dependent(:destroy) }
  end
end

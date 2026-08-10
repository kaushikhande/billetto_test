require "rails_helper"

RSpec.describe VoteService do
  let!(:event) { create(:event) }
  let!(:user) { create(:user) }
  let(:event_store) { RailsEventStore::Client.new }

  describe "#call" do
    it "creates an upvote and publishes an EventUpvoted event" do
      expect {
        described_class.new(
          event: event,
          user: user,
          vote_type: :upvote
        ).call
      }.to change(Vote, :count).by(1)

      vote = Vote.last

      expect(vote.event).to eq(event)
      expect(vote.user).to eq(user)
      expect(vote.vote_type).to eq("upvote")

      stored_events = event_store.read
      stored_event = stored_events.last

      expect(stored_event).to be_a(EventUpvoted)

      expect(stored_event.data).to include(
        event_id: event.id,
        user_id: user.id
      )
    end

    it "creates a downvote and publishes an EventDownvoted event" do
      expect {
        described_class.new(
          event: event,
          user: user,
          vote_type: :downvote
        ).call
      }.to change(Vote, :count).by(1)

      vote = Vote.last

      expect(vote.vote_type).to eq("downvote")

      stored_event = event_store.read.last

      expect(stored_event).to be_a(EventDownvoted)
      expect(stored_event.data).to include(
        event_id: event.id,
        user_id: user.id
      )
    end
  end
end

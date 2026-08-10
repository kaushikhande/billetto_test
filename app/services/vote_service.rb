class VoteService
  attr_reader :event, :user, :vote_type

  def initialize(event:, user:, vote_type:)
    @event = event
    @user = user
    @vote_type = vote_type
    @event_store = Rails.configuration.event_store
  end

  def call
    Vote.transaction do
      vote = Vote.find_or_initialize_by(
        event: event,
        user: user
      )

      vote.update!(
        vote_type: vote_type
      )

      publish_event
    end
  end

  private

  def publish_event
    event_class =
      vote_type == :upvote ? EventUpvoted : EventDownvoted

    @event_store.publish(
      event_class.new(
        data: {
          event_id: event.id,
          user_id: user.id,
          vote_type: vote_type
        }
      ),
      stream_name: "Event$#{event.id}"
    )
  end
end

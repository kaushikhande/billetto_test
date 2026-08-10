class EventsController < ApplicationController
  before_action :require_authentication, only: [:upvote, :downvote]

  def index
    # @events = Event.includes(:votes).all
    @events = Event
      .left_joins(:votes)
      .select(
        "events.*",
        "COUNT(CASE WHEN votes.vote_type = 1 THEN 1 END) AS upvotes_count",
        "COUNT(CASE WHEN votes.vote_type = 0 THEN 1 END) AS downvotes_count"
      )
      .group("events.id")
  end

  def upvote
    vote(:upvote)
  end

  def downvote
    vote(:downvote)
  end

  private

  def vote(vote_type)
    event = Event.find(params[:id])

    VoteService.new(
      event: event,
      user: current_user,
      vote_type: vote_type
    ).call

    redirect_to events_path
  end
end

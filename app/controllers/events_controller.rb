class EventsController < ApplicationController
  before_action :require_authentication, only: [:upvote, :downvote]

  def index
    @events = Event.includes(:votes).all
  end

  def upvote
    puts "Here we are"
    pp clerk
    vote(:upvote)
  end

  def downvote
    vote(:downvote)
  end

  private

  def vote(vote_type)
    event = Event.find(params[:id])

    vote = Vote.find_or_initialize_by(
      event: event,
      user: current_user
    )

    vote.update!(vote_type: vote_type)

    redirect_to events_path
  end
end

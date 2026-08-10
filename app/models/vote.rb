class Vote < ApplicationRecord
	belongs_to :user
  belongs_to :event

  enum :vote_type, {
    upvote: 1,
    downvote: 0
  }
end

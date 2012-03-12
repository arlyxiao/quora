class AnswerVote < ActiveRecord::Base
  validates :user_id, :answer_id, :is_vote_up, :presence => true
end

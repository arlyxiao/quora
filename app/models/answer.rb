class Answer < ActiveRecord::Base
  # --- 模型关联
  belongs_to :question
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  
  # --- 校验方法
  validates :creator, :question, :content, :presence => true
  # --- 限制不能重复回答
  validates :question_id, :uniqueness=>{:scope => :creator_id} 
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :answers, :foreign_key => :creator_id
      base.has_many :answered_questions, :through => :answers, :source => :question
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # 赞成
      def agree(answer)
        Answer.increment_counter(:vote_sum, answer.id)
        AnswerVote.create(:user_id => self.id, :answer_id => answer.id, :is_vote_up => true)
      end
      
      # 反对
      def disagree
        Answer.decrement_counter(:vote_sum, answer.id)
        AnswerVote.create(:user_id => self.id, :answer_id => answer.id, :is_vote_up => false)
      end
    end
  end
end

class Answer < ActiveRecord::Base
  # --- 模型关联
  belongs_to :question
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  
  has_many :answer_votes
  
  # --- 校验方法
  validates :creator, :question, :content, :presence => true
  # --- 限制不能重复回答
  validates :question_id, :uniqueness=>{:scope => :creator_id} 
  
  # 投加分票
  def vote_up_by!(user)
    self.answer_votes.create!(:user => user, :is_vote_up => true)
    self.reload
    # 修改 vote_sum 的逻辑已经挪到 answer_vote 的创建回调中了
    # 必须reload，否则当前对象上的vote_sum值不会变
  end
  
  # 投反对票
  def vote_down_by!(user)
    self.answer_votes.create!(:user => user, :is_vote_up => false)
    self.reload
  end
  
  # 为了避免user上方法过多，从user上把逻辑挪到了answer上。
  
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :answers, :foreign_key => :creator_id
      base.has_many :answered_questions, :through => :answers, :source => :question
    end
  end

  # 引用其它类
  include Comment::CommentableMethods  

end

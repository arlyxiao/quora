class Question < ActiveRecord::Base
  # --- 模型关联
  has_many :answers, :dependent => :destroy, :order=>'vote_sum DESC'
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  
  # --- 校验方法
  validates :creator, :title, :content, :presence => true
  
  def is_answered_by(user)
    return false if user.blank?
    self.answers.where(:creator_id => user.id).exists?
  end
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      # 用户提问的问题列表
      base.has_many :asked_questions, :class_name=>'Question', 
        :foreign_key => :creator_id, :order=>'id DESC'
    end
  end

  # 引用其它类
  include Comment::CommentableMethods
  include Tagging::TaggableMethods
end

class Question < ActiveRecord::Base
  # --- 模型关联
  has_many :answers, :dependent => :destroy
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  
  # --- 校验方法
  validates :creator, :title, :content, :presence => true
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :questions, :foreign_key => :creator_id
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # nothing ...
    end
  end
end

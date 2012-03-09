class ShortMessage < ActiveRecord::Base
  # --- 模型关联
  has_many :short_message_readings
  belongs_to :sender, :class_name => 'User', :foreign_key => :sender_id
  belongs_to :receiver, :class_name => 'User', :foreign_key => :receiver_id
  accepts_nested_attributes_for :short_message_readings

  # --- 校验方法
  validates :sender, :receiver, :content, :presence => true
  validates_length_of :content, :maximum => 500, :message => "不能超过 %d 个字"
  

  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      # base.has_many :short_messages, :foreign_key => :sender_id
      # base.has_many :short_messages, :foreign_key => :receiver_id
      # 不能这样针对不同的 key 重复声明同名的has_many，需要声明不同的名称。
      # 暂时也没有用到，先注释掉了
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
=begin
      def exchanged_messages_with(user)
        ShortMessage.find(
          :all,
          :order => 'id DESC',
          :conditions => [
            %~
              (sender_id = ? AND receiver_id = ? AND sender_hide IS FALSE)
              OR 
              (sender_id = ? AND receiver_id = ? AND receiver_hide IS FALSE)
            ~, 
            self.id, user.id, # 由我发送的消息
            user.id, self.id  # 由我接收的消息
          ]
        )
      end
=end
    end
  end
  
end

require 'uuidtools'
class OnlineRecord < ActiveRecord::Base
  belongs_to :user
  
  def self.onlines
    all.includes(:user).order('created_at DESC')
  end
  
  def self.online_users
    all.where('user_id is not null').order('created_at DESC')
  end
  
  def self.online_guests
    all.where('user_id is null').order('created_at DESC')
  end
  
  def self.refresh(user)
    tidy
    unless user.nil?
      rec=find_or_create_by_user_id(user.id)
      rec.user=user
      rec.updated_at=Time.now if rec.updated_at.blank? || Time.now-rec.updated_at>5.minutes
      rec.save
    end
  end
  
  def self.refresh_anonymous(online_key)
    tidy
    online_key ||= UUID.random_create.to_s
    rec=find_or_create_by_key(online_key)
    rec.updated_at=Time.now if rec.updated_at.blank? || Time.now-rec.updated_at>5.minutes
    rec.save
    online_key
  end
  
  # 在线时长
  def onlinetime
    Time.now-created_at
  end
  
  # 清理在线列表，清除超时的访问记录
  # 这个应该改成由系统定时任务来调用，以提高系统运行效率
  def self.tidy
    all.each do |o|
      o.destroy if Time.now-o.updated_at>10.minutes
    end
  end
  
  # 总在线人数
  def self.onlinecount
    tidy
    count
  end
  
  # 在线用户数
  def self.usercount
    tidy
    all.where('user_id is not null').count
  end
  
  # 在线非用户数
  def self.anonycount
    tidy
    all.where('user_id is null').count
  end
  
  def self.clear_online_key(key)
    if !key.nil? && !(rec=OnlineRecord.find_by_key(key)).nil?
      rec.destroy
    end
  end
  
  module UserMethods
    def self.included(base)
      base.has_one :online_record, :dependent => :destroy
    end
  end
end

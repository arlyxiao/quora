class Notification < ActiveRecord::Base
  validates :user_id, :resource_id, :resource_type, :creator_id, :presence => true
end

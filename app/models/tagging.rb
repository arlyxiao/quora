class Tagging < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :model, :polymorphic => true
  belongs_to :tag
  
  validates :tag, :creator, :model, :presence => true
  
  module TaggableMethods
    def self.included(base)
      base.has_many :taggings,:as=>:model
      base.has_many :tags, :through=>:taggings
      base.send(:include,InstanceMethods)
    end
    module InstanceMethods
      def add_tag(user,name)
        tag = Tag.get(name)
        tagging = self.taggings.where(:tag_id=>tag.id).first
        if tagging.blank?
          self.taggings.create(:tag=>tag,:creator=>user)
        end
        tag
      end
      
      def remove_tag(name)
        tag = Tag.where(:name=>name).first
        if !tag.blank?
          tagging = self.taggings.where(:tag_id=>tag.id).first
          tagging.destroy if !tagging.blank?
        end
        tag
      end
    end
  end
end

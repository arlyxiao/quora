class Tag < ActiveRecord::Base
  validates :name, :presence => true
  
  def self.get(name)
    tag = Tag.where(:name=>name).first
    
    if tag.blank?
      tag = Tag.create!(:name=>name)
    end
    
    tag
  end
end

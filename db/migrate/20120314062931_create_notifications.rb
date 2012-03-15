class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.text :content
      t.boolean :is_read, :default => false
		  t.string :resource_type
		  t.integer :resource_id
		  t.integer :creator_id

      t.timestamps
    end
  end
end

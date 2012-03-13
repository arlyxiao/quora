class CreateComments < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'comments' then
		  create_table :comments do |t|
		    t.integer     :model_id
		    t.string      :model_type
		    t.integer     :creator_id
		    t.text        :content
		    t.integer     :reply_comment_id
		    t.integer     :reply_comment_user_id
		    t.timestamps
		  end
    end
  end
end

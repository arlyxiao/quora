class CreateAnswerVotes < ActiveRecord::Migration
  def change
    create_table :answer_votes do |t|
      t.integer :user_id
      t.integer :answer_id
      t.boolean :is_vote_up, :default => false

      t.timestamps
    end
  end
end

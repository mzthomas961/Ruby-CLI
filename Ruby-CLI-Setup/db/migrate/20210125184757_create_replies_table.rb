class CreateRepliesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :replies do |t|
      t.integer :user_id
      t.integer :forum_thread_id
      t.string :body
      t.timestamps
    end
  end
end

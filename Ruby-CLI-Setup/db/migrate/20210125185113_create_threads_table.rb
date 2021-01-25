class CreateThreadsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :forum_threads do |t|
      t.integer :user_id
      t.string :body
      t.string :title
      t.timestamps
    end
  end
end

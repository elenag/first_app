class CreatePushes < ActiveRecord::Migration
  def change
    create_table :pushes do |t|
      t.references :book
      t.references :content_bucket
      t.date "push_date"
      t.boolean "successful"
      t.text "comments"
      t.timestamps
    end
    add_index :pushes, ['book_id', 'content_bucket_id']
  end
end

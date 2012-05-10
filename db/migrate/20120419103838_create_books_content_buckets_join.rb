class CreateBooksContentBucketsJoin < ActiveRecord::Migration
  def up
  	create_table :books_content_buckets, :id=>false do |t|
  		t.integer "book_id"
  		t.integer "content_bucket_id"
  	end
  	add_index :books_content_buckets, ["book_id", "content_bucket_id"]
  end

  def down
  	drop_table :books_content_buckets
  end
end

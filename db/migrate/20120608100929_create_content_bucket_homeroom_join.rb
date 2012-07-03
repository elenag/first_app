class CreateContentBucketHomeroomJoin < ActiveRecord::Migration
  def up
  	create_table :content_buckets_homerooms, :id=>false do |t|
  		t.integer "content_bucket_id"
  		t.integer "homeroom_id"
  	end
  	add_index :content_buckets_homerooms, ["content_bucket_id", "homeroom_id"], :unique => true, :name => 'content_bucket_homeroom_index'

  end

  def down
  	drop_table :content_buckets_homerooms
  end
end

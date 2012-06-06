class CreateAccountsContentBucketsJoin < ActiveRecord::Migration
  def up
  	create_table :accounts_content_buckets, :id=>false do |t|
  		t.integer "account_id"
  		t.integer "content_bucket_id"
  	end
  	add_index :accounts_content_buckets, ["account_id", "content_bucket_id"], :unique => true, :name => 'account_content_bucket_index'

  end

  def down
  	drop_table :accounts_content_buckets
  end
end

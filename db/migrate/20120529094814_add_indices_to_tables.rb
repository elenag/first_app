class AddIndicesToTables < ActiveRecord::Migration
  def change
  	add_index("origins", "continent_id")
  	add_index("projects", ["origin_id", "model_id"])
  	add_index("schools", "project_id")
  	rename_table("sclasses", "homerooms")
  	add_index("homerooms","school_id")
  	remove_column("accounts", "sclass_id")
  	add_column("accounts", "homeroom_id", :integer)
  	add_index("accounts", ["homeroom_id", "school_id"])
  	add_index("devices", ["account_id", "purchase_order_id", "device_type_id"], :name => 'device_account_po_dt_index')
  	add_index("events", "device_id")
  	
  	rename_column("books", "flaged", "flagged")
  	add_index :books, ["language_id", "publisher_id", "genre_id"], :unique => true, :name => 'books_language_publisher_genre_index'
  	remove_index :books_prights, ["book_id", "pright_id"]
  	remove_column("books_prights", "pright_id")
  	rename_table("prights", "publishing_rights")
  	rename_table("books_prights", "books_publishing_rights") 
    add_column("books_publishing_rights","publishing_right_id", :integer)
  	add_index :books_publishing_rights, ["book_id", "publishing_right_id"], :unique => true, :name => 'book_publishing_right_index'

  	remove_index("accounts_content_buckets", :name=>"account_content_bucket_index")
  	remove_column :accounts_content_buckets, :account_id
  	rename_table("accounts_content_buckets", "homerooms_content_buckets")
    add_column :homerooms_content_buckets, "homeroom_id", :integer
  	add_index :homerooms_content_buckets, ["homeroom_id", "content_bucket_id"], :unique => true, :name => 'homeroom_content_bucket_index'

  	add_index("authors", "origin_id")
  	add_index("publishers", "origin_id")
  end
end

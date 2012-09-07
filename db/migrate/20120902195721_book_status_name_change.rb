class BookStatusNameChange < ActiveRecord::Migration
  def up
  	rename_table :book_appstatuses, :appstatuses
  	remove_index "books", ["status_id", "appstatus_id"]
  	rename_column :books, :status_id, :book_status_id
  	add_index "books", ["book_status_id", "appstatus_id"]
  end

  def down
  	rename_table :appstatuses, :book_appstatuses
  	remove_index "books", ["book_status_id", "appstatus_id"]
  	add_index "books", ["status_id", "appstatus_id"]
  end
end

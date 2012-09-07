class AddBooksStatusKeys < ActiveRecord::Migration
  def up
  	remove_column("books", "status")
  	add_column("books", "status_id", "integer")
  	remove_column("books", "appstatus")
  	add_column("books", "appstatus_id", "integer")
  	add_index "books", ["status_id", "appstatus_id"]
  	add_index("books", "fiction_type_id")
  	add_index("books", "textbook_level_id")
  	add_index("books", "textbook_subject_id")
  end

  def down
  	remove_column("books", "status_id")
  	add_column("books", "status", "string")
  	remove_column("books", "appstatus_id")
  	add_column("books", "appstatus", "string")
  	remove_index "books", ["status_id", "appstatus_id"]
  	remove_index("books", "fiction_type_id")
  	remove_index("books", "textbook_level_id")
  	remove_index("books", "textbook_subject_id")
  end
end

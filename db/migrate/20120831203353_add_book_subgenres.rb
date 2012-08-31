class AddBookSubgenres < ActiveRecord::Migration
  def up
  	add_column("books", "fiction_type_id", "integer")
  	add_column("books", "textbook_level_id", "integer")
  	add_column("books", "textbook_subject_id", "integer")
  end

  def down
  	remove_column("books", "fiction_type_id")
  	remove_column("books", "textbook_level_id")
  	remove_column("books", "textbook_subject_id")
  end
end

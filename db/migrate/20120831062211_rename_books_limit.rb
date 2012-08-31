class RenameBooksLimit < ActiveRecord::Migration
  def up
  	remove_column("books", "limit", "integer")
  	add_column("books", "limited", "integer")
  end

  def down
  	add_column("books", "limit", "integer")
  	remove_column("books", "limited", "integer")
  end
end

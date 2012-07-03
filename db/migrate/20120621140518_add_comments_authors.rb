class AddCommentsAuthors < ActiveRecord::Migration
  def up
  	add_column("authors", "comments", "text")
  end

  def down
  	remove_column("authors", "comments")
  end
end

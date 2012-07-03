class AddStatusToBooks < ActiveRecord::Migration
  def change
  	add_column("books", "date_added", "date")
  	add_column("books", "status", "string")
  	add_column("books", "restricted", "boolean")
  end
end

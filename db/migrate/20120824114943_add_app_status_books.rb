class AddAppStatusBooks < ActiveRecord::Migration
  def change
  	add_column("books", "appstatus", "string")
  	add_column("books", "limit", "integer")
  end
end

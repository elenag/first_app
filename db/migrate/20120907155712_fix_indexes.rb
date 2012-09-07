class FixIndexes < ActiveRecord::Migration
  def up
    remove_index "admin_users_projects", :name => "admin_user_project_index"
    add_index "admin_users_projects", ["admin_user_id", "project_id"], :name => "admin_user_project_index"
    remove_index "students", :name => "index_students_on_account_id"
    add_index "students", ["account_id"]
  	remove_index "books", :name => "altered_books_language_publisher_genre_index"
  	add_index "books", :language_id
  	add_index "books",  :publisher_id
  	add_index "books", :genre_id
  end

  def down
  end
end

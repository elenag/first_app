class AddAdminUsersProjectsIds < ActiveRecord::Migration
  def up
  	add_column("projects", "admin_user_id", "integer")
  end

  def down
  	remove_column("projects", "admin_user_id")
  end
end

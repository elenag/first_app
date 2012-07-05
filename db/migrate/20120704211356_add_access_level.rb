class AddAccessLevel < ActiveRecord::Migration
  def up
  	add_column("admin_users", "can_edit_origins", "boolean")
  end

  def down
  	remove_column("admin_users", "can_edit_origins")
  end
end

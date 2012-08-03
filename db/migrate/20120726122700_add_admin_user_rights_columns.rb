class AddAdminUserRightsColumns < ActiveRecord::Migration
  def up
  	add_column("admin_users", "ops_rel", "boolean")
  	add_column("admin_users", "publishing_rel", "boolean")
  	add_column("admin_users", "DR_rel", "boolean")
  end

  def down
  	remove_column("admin_users", "ops_rel")
  	remove_column("admin_users", "publishing_rel")
  	remove_column("admin_users", "DR_rel")
  end
end

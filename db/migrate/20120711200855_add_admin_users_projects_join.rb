class AddAdminUsersProjectsJoin < ActiveRecord::Migration
  def up
  	create_table :admin_users_projects, :id=>false do |t|
  		t.integer "admin_user_id"
  		t.integer "project_id"
  	end
  	add_index :admin_users_projects, ["admin_user_id", "project_id"], :unique => true, :name => 'admin_user_project_index'

  end

  def down
  	drop_table :admin_users_projects
  end
end
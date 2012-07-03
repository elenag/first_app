class AddRoleStudents < ActiveRecord::Migration
  def up
  	remove_column("students", "teacher")
  	add_column("students", "role", "string")
  end

  def down
  	remove_column("students", "role")
  	add_column("students", "teacher", "boolean")
  end
end

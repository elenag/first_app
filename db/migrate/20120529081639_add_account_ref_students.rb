class AddAccountRefStudents < ActiveRecord::Migration
  def up
  	add_column("students", "account_id", "integer")
  	add_index("students", "account_id", :unique => true)
  end

  def down
  	remove_column("students", "account_id")
  	remove_index("students", "account_id")
  end
end

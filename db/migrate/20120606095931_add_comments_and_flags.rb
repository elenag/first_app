class AddCommentsAndFlags < ActiveRecord::Migration
  def change
  	add_column("projects", "target_size", "integer")
  	add_column("projects", "current_size", "integer")
  	add_column("projects", "comments", "text")
  	add_column("accounts", "number_broken", "integer")
  	add_column("accounts", "flagged", "boolean")
  	add_column("accounts", "comments", "text")
  	add_column("students", "teacher", "boolean")
  	add_column("students", "comments", "text")
  	add_column("purchase_orders", "date_ordered", "date")
  	add_column("purchase_orders", "date_received", "date")
  end
end

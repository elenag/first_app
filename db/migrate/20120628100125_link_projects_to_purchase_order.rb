class LinkProjectsToPurchaseOrder < ActiveRecord::Migration
  def up
  	remove_column("purchase_orders", "date_received")
  	add_column("purchase_orders", "warranty_end_date", "date")
  	add_column("purchase_orders", "project_id", "integer")
  	add_column("purchase_orders", "comments", "text")
  end

  def down
  	remove_column("purchase_orders", "warranty_end_date")
  	remove_column("purchase_orders", "project_id")
  	remove_column("purchase_orders", "comments")
  end
end

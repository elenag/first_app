class AddReturnReasonDevices < ActiveRecord::Migration
  def up
  	add_column("devices", "return_reason", "string")
  	add_column("devices", "comments", "text")
  end

  def down
  	remove_column("devices", "return_reason")
  end
end

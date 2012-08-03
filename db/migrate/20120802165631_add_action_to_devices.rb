class AddActionToDevices < ActiveRecord::Migration
  def change
  	add_column("devices", "action", "string")
  end
end

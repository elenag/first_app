class AddStatusToDevicesAndAccounts < ActiveRecord::Migration
  def change
  	add_column("accounts", "status", "string")
  	add_column("devices", "status", "string")
  end
end

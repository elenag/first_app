class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
        t.string "serial_number"
        t.boolean "flagged", :default => false
        t.integer "control"
        t.boolean "reinforced_screen", :default => false
        t.references :device_type
        t.references :account
        t.references :purchase_order
        t.timestamps
    end
  end
end


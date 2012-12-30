class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.boolean "confirmed", :default => false
      t.references :admin_user
      t.references :project
      t.timestamps
    end
  end
end

class AddInStoreToBooks < ActiveRecord::Migration
  def change
  	add_column :books, :in_store, :boolean
  end
end

class AddCathegoriesToBooks < ActiveRecord::Migration
  def change
  	add_column :books, :category_id, :integer
  	add_column :books, :subcategory_id, :integer
  	add_index :books, :category_id
  	add_index :books, :subcategory_id
  end
end

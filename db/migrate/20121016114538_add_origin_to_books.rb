class AddOriginToBooks < ActiveRecord::Migration
  def change
  	add_column :books, :origin_id, :int
  end
end

class CreateBooksLevelsJoin < ActiveRecord::Migration
  def up
  	create_table :books_levels, :id=>false do |t|
  		t.integer "book_id"
  		t.integer "level_id"
  	end
  	add_index :books_levels, ["book_id", "level_id"]
  end

  def down
  	drop_table :books_levels
  end
end

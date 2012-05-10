class CreateBooksPlatformsJoin < ActiveRecord::Migration
  def up
  	create_table :books_platforms, :id=>false do |t|
  		t.integer "book_id"
  		t.integer "platform_id"
  	end
  	add_index :books_platforms, ["book_id", "platform_id"]
  end

  def down
  	drop_table :books_platforms
  end
end

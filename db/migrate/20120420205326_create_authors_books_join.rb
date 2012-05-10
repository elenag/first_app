class CreateAuthorsBooksJoin < ActiveRecord::Migration
  def up
  		create_table :authors_books, :id=>false do |t|
  		t.integer "book_id"
  		t.integer "author_id"
  	end
  	add_index :authors_books, ["book_id", "author_id"]
  end

  def down
  	drop_table :authors_books
  end
end

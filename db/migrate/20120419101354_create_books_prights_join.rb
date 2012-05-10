class CreateBooksPrightsJoin < ActiveRecord::Migration
  def up
  	create_table :books_prights, :id=>false do |t|
  		t.integer "book_id"
  		t.integer "pright_id"
  	end
  	add_index :books_prights, ["book_id", "pright_id"]
  end

  def down
  	drop_table :books_prights
  end
end

class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
    	t.string "asin"
    	t.string "title"
    	t.decimal "price"
    	t.integer "rating"
    	t.boolean "flaged", :default => false
        t.boolean "copublished"
    	t.references :publisher
    	t.references :language
    	t.references :genre
    	t.text "comments"      
    	t.timestamps
    end
  end
end

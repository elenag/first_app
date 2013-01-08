class AddKeywordNewLevelsBooks < ActiveRecord::Migration
  def up
  	add_column :books, :keywords, :string
  	add_column :books, :read_level_id, :integer
  	add_column :books, :textbook_sumlevel_id, :integer
    add_index :books, :read_level_id
    add_index :books, :textbook_sumlevel_id
  end

  def down
  	remove_column :books, :keywords
  	remove_index :books, :read_level_id
  	remove_column :books, :read_level_id
  	remove_index :books, :textbook_sumlevel_id
  	remove_column :books, :textbook_sumlevel_id
  end
end

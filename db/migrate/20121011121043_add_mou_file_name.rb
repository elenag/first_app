class AddMouFileName < ActiveRecord::Migration
  
  def change
  	add_column :books, :mou_fname, :string
  	rename_column :books, :comments, :description
    add_column :books, :comments, :text
  	add_column :books, :source_file, :boolean
  	add_column :books, :source_cover, :boolean
  	add_column :books, :mobi, :boolean
  	add_column :books, :epub, :boolean
  	add_column :books, :fixed_epub, :boolean
  end

end

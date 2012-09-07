class CreateBookAppstatuses < ActiveRecord::Migration
  def change
    create_table :book_appstatuses do |t|
      t.string "name"
      t.timestamps
    end
  end
end

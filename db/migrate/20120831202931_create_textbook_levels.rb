class CreateTextbookLevels < ActiveRecord::Migration
  def change
    create_table :textbook_levels do |t|
      t.string "name"
      t.timestamps
    end
  end
end

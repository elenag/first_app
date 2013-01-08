class CreateTextbookSumlevels < ActiveRecord::Migration
  def change
    create_table :textbook_sumlevels do |t|
      t.string "name"
      t.timestamps
    end
  end
end

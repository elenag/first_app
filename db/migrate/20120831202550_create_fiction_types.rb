class CreateFictionTypes < ActiveRecord::Migration
  def change
    create_table :fiction_types do |t|
      t.string "name"
      t.timestamps
    end
  end
end

class CreateReadLevels < ActiveRecord::Migration
  def change
    create_table :read_levels do |t|
      t.string "name"
      t.timestamps
    end
  end
end

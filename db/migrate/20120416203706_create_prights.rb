class CreatePrights < ActiveRecord::Migration
  def change
    create_table :prights do |t|
        t.string "name"
        t.timestamps
    end
  end
end

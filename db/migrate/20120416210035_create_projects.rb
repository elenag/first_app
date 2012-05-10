class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
        t.string "name"
        t.references :model
        t.references :origin
        t.timestamps
    end
  end
end

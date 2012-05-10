class CreatePublishers < ActiveRecord::Migration
  def change
    create_table :publishers do |t|
    	t.string "name"
    	t.references :origin
        t.timestamps
    end
  end
end

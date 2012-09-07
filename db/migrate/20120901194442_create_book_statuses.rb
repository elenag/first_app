class CreateBookStatuses < ActiveRecord::Migration
  def change
    create_table :book_statuses do |t|
      t.string "name"
      t.timestamps
    end
  end
end

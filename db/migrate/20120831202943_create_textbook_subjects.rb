class CreateTextbookSubjects < ActiveRecord::Migration
  def change
    create_table :textbook_subjects do |t|
      t.string "name"
      t.timestamps
    end
  end
end

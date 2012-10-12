class CreatePubContacts < ActiveRecord::Migration
  def change
    create_table :pub_contacts do |t|
      t.string "name"
      t.string "email"
      t.string "telephone"
      t.string "comments"
      t.integer "publisher_id"
      t.timestamps
    end

    add_index :pub_contacts, ['publisher_id']
  end
end

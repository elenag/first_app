class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order
      t.references :book
      t.references :content_bucket
      t.timestamps
    end
    add_index :order_items, ['order_id', 'book_id']
  end
end

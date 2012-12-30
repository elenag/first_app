class OrderItem < ActiveRecord::Base
    attr_accessible :book_id, :content_bucket_id, :order_id

    belongs_to :order
    belongs_to :content_bucket
    belongs_to :book

end

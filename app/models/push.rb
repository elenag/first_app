class Push < ActiveRecord::Base
   attr_accessible :date, :successful, :comments, :book_id, :content_bucket_id

   belongs_to :book
   belongs_to :content_bucket

   validates :date, :book_id, :content_bucket_id, :presence => true
end

class Push < ActiveRecord::Base
   attr_accessible :push_date, :successful, :comments, :book_id, :content_bucket_id

   belongs_to :book
   belongs_to :content_bucket

   has_one :project, :through => :content_bucket
  
   validates :push_date, :book_id, :content_bucket_id, :presence => true

   class << self
      def this_month
        where('push_date >= ?', Date.new(Time.now.year, Time.now.month, 1).to_datetime)
      end
    end
end

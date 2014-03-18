class TextbookLevel < ActiveRecord::Base
  attr_accessible :name,:origin_id

   has_many :books
   belongs_to :origin
end

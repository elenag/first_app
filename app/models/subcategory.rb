class Subcategory < ActiveRecord::Base
   attr_accessible :name, :category_id, :book_attributes

   belongs_to :book
   belongs_to :category
end

class Category < ActiveRecord::Base
  attr_accessible :name, :books_attributes, :id

  has_many :books
  has_many :subcategories
end

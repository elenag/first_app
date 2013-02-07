class Category < ActiveRecord::Base
  attr_accessible :name, :books_attributes, :subcategories_attributes, :id

  has_many :books
  has_many :subcategories
  accepts_nested_attributes_for :subcategories, :allow_destroy => true
end

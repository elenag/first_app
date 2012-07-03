class Genre < ActiveRecord::Base
  attr_accessible :name

  has_many :books
  accepts_nested_attributes_for :books

  validates :name, :presence => true
end

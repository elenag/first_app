class Level < ActiveRecord::Base
  attr_accessible :name
  #accepts_nested_attributes_for :books

  has_and_belongs_to_many :books
  validates :name, :presence => true
  
end

class Level < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :books, :join_table => :books_levels
  validates :name, :presence => true
  
end

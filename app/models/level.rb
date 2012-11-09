class Level < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :books
  validates :name, :presence => true
  
end

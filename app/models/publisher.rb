class Publisher < ActiveRecord::Base
  attr_accessible :name, :origin_id
 

  has_many :books
  belongs_to :origin, :include => :continent

  accepts_nested_attributes_for :origin


  validates :name, :origin_id, :presence => true
end

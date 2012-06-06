class Publisher < ActiveRecord::Base
  attr_accessible :name, :origin_id
 # accepts_nested_attributes_for :books

  has_many :books
  belongs_to :origin

  validates :name, :presence => true
end

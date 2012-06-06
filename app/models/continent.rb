class Continent < ActiveRecord::Base
  attr_accessible :name

  has_many :origins
  accepts_nested_attributes_for :origins

  validates :name, :presence => true
end

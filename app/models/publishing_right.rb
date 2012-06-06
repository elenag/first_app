class PublishingRight < ActiveRecord::Base
  attr_accessible :name, :id
  has_and_belongs_to_many :books

  validates :name, :presence => true
end

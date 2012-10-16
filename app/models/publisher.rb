class Publisher < ActiveRecord::Base
  attr_accessible :name, :origin_id
 

  has_many :books
  has_many :pub_contacts
  belongs_to :origin, :include => :continent

  accepts_nested_attributes_for :origin, :books, :pub_contacts

  validates :name, :origin_id, :presence => true
end

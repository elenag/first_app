class Origin < ActiveRecord::Base
  attr_accessible :name, :id

  belongs_to :continent
  has_many :projects
  accepts_nested_attributes_for :projects, :allow_destroy => true
  has_many :authors
  accepts_nested_attributes_for :authors
  has_many :publishers
  
  validates :name, :presence => true

end

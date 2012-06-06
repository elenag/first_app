class Homeroom < ActiveRecord::Base
  attr_accessible :homeroom_id, :name, :school_id, :accounts_attributes
  
  has_many :accounts
  accepts_nested_attributes_for :accounts, :allow_destroy => true

  belongs_to :school

  validates :name, :presence => true
end


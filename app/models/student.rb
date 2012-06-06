class Student < ActiveRecord::Base
  attr_accessible :first_name, :other_names, :account_id, :teacher, :comments
  
  belongs_to :account


  validates :first_name, :other_names, :presence => true
  
end

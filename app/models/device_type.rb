class DeviceType < ActiveRecord::Base
  attr_accessible :name
 
  has_many :devices

  validates :name, :presence => true
end

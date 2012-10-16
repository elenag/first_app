class PubContact < ActiveRecord::Base
  attr_accessible :id, :name, :email, :telephone, :comments, :publisher_id

  belongs_to :publisher
  accepts_nested_attributes_for :publisher

end

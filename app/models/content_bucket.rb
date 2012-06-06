class ContentBucket < ActiveRecord::Base
  # attr_accessible :title, :body
  has_and_belongs_to_many :books
  has_and_belongs_to_many :accounts
  
  validates :name, :presence => true
end

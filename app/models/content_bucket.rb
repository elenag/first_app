class ContentBucket < ActiveRecord::Base
  attr_accessible :name, :content_bucket_id, :project_id
  
  has_many :pushes #, :join_table => :books_content_buckets
  accepts_nested_attributes_for :pushes
  has_many :books, :through => :pushes
  accepts_nested_attributes_for :books
  
  belongs_to :project
  has_many :schools, :through => :project
  has_and_belongs_to_many :homerooms, :join_table => :content_buckets_homerooms
  accepts_nested_attributes_for :homerooms

  validates :name, :presence => true
end

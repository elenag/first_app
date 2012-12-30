class ContentBucket < ActiveRecord::Base
  attr_accessible :name, :content_bucket_id, :project_id, :pushes_attributes #, :push_date, :successful, :comment
  
  has_many :pushes #, :join_table => :books_content_buckets
  accepts_nested_attributes_for :pushes, :allow_destroy => true
  has_many :books, :through => :pushes
  accepts_nested_attributes_for :books
  
  belongs_to :project
  has_many :schools, :through => :project
  has_and_belongs_to_many :homerooms, :join_table => :content_buckets_homerooms
  accepts_nested_attributes_for :homerooms

  has_many :accounts, :through => :homerooms
  has_many :students, :through => :accounts

  has_many :order_items

  validates :name, :presence => true

  def self.projects_content_buckets (proj_id)
      @content_buckets = ContentBucket.where(:project_id => proj_id)
  end
end

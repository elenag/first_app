class Homeroom < ActiveRecord::Base
  attr_accessible :homeroom_id, :name, :school_id, :content_bucket_ids, :accounts_attributes, :content_bucket_attributes
  
  has_many :accounts
  accepts_nested_attributes_for :accounts

  belongs_to :school
  has_one :project, :through => :school
  has_and_belongs_to_many :content_buckets, :join_table => :content_buckets_homerooms
  accepts_nested_attributes_for :content_buckets
  has_many :pushes, :through => :content_bucket
  has_many :books, :through => :pushes

  validates :name, :school_id, :presence => true
end



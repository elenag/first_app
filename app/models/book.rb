class Book < ActiveRecord::Base
  attr_accessible :asin, :title, :price, :rating, :copublished, :flagged, :author_ids, :publishing_right_ids, :publisher_id, :genre_id, :language_id, :level_ids, :comments, :authors_attributes

  has_and_belongs_to_many :levels
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :publishing_rights

  has_and_belongs_to_many :authors, :join_table => :authors_books
  accepts_nested_attributes_for :authors
  
  has_and_belongs_to_many :content_buckets

  belongs_to :language
  belongs_to :genre
  belongs_to :publisher

end

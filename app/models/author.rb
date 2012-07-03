class Author < ActiveRecord::Base
  attr_accessible :name, :id, :books_attributes, :origin_id, :comments

  belongs_to :origin

  has_and_belongs_to_many :books, :join_table => :authors_books
  accepts_nested_attributes_for :books

  validates :name, :origin_id, :presence => true
end

class Book < ActiveRecord::Base
  STATUS_WAITING_PDF = 'waiting_pdf'
  STATUS_SENT_TO_CONVERT = 'sent_to_convert'
  STATUS_PROBLEM_WITH_PDF = 'problem_pdf'
  STATUS_PROBLEM_WITH_MOBI = 'problem_mobi'
  STATUS_WAITING_PUBLISHING =  'waiting_publishing' 
  STATUS_IN_REVIEW = 'in_review'
  STATUS_PUBLISHED_AMAZON = 'publish_amazon'
  STATUS_PUBLISHED_APP = 'publish_app'
  STATUS_PUBLISHED_BOTH = 'publish_both'
  STATUS_OTHER = 'other'
 

  attr_accessible :asin, :title, :price, :rating, :copublished, :flagged, :status, :author_ids, 
        :publishing_right_ids, :publisher_id, :genre_id, :language_id, :level_ids,
        :comments, :authors_attributes, :content_bucket_ids, :push_ids, :restricted, :date_added

  has_and_belongs_to_many :levels
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :publishing_rights

  has_and_belongs_to_many :authors, :join_table => :authors_books
  accepts_nested_attributes_for :authors
  
  has_many :pushes
  has_many :content_buckets, :through => :pushes

  belongs_to :language
  belongs_to :genre
  belongs_to :publisher, :include => :origin

  has_one :origin, :through => :publisher
  has_one :continent, :through => :origin


  validates :status, :inclusion => { :in => [STATUS_OTHER, STATUS_PUBLISHED_APP, STATUS_PUBLISHED_AMAZON, STATUS_PUBLISHED_BOTH, STATUS_IN_REVIEW, STATUS_SENT_TO_CONVERT,
      STATUS_WAITING_PUBLISHING, STATUS_WAITING_PDF, STATUS_PROBLEM_WITH_MOBI, STATUS_PROBLEM_WITH_PDF], :message =>"You need to specify a book status" }
  validates :title, :status, :date_added, :publisher_id, :language_id, :genre_id, :author_ids, :presence => true

  #scope :publish, lambda { where :status => 'published' }

  class << self
    def books_status_collection
      {
        "Waiting for PDF" => STATUS_WAITING_PDF,
        "Sent to convert" => STATUS_SENT_TO_CONVERT,
        "Problem with PDF" => STATUS_PROBLEM_WITH_PDF,
        "Problem with Mobi" => STATUS_PROBLEM_WITH_MOBI,
        "Awaiting publishing" => STATUS_WAITING_PUBLISHING,
        "In Review at Amazon" => STATUS_IN_REVIEW, 
        "Published on Amazon" => STATUS_PUBLISHED_AMAZON,
        "Published on App" => STATUS_PUBLISHED_APP,
        "Published on Both" => STATUS_PUBLISHED_BOTH,
        "Other" => STATUS_OTHER
      }
    end
    def not_pushed_to 
#    @books = Book.all.where(:content_bucket_ids)
   end

  end

end

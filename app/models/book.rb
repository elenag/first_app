class Book < ActiveRecord::Base
  # STATUS_WAITING_ON_PDF = 'waiting_on_pdf'
  # STATUS_SENT_TO_CONVERT = 'sent_to_convert'
  # STATUS_PROBLEM_WITH_PDF = 'problem_with_pdf'
  # STATUS_PROBLEM_WITH_MOBI = 'problem_with_mobi'
  # STATUS_WAITING_TO_BE_PUBLISHED =  'waiting_publishing' 
  # STATUS_NA = 'N/A'
  # STATUS_PUBLISHED_AMAZON = 'published_on_amazon'
  # STATUS_OTHER = 'other'
  # APPSTATUS_NA = 'app_N/A'
  # APPSTATUS_PUBLISHED = 'published'
  # APPSTATUS_WAITING_ON_FILE = 'app_waiting_on_file'
  # APPSTATUS_WAITING_TO_PUBLISH = 'app_waiting_to_publish'
  # APPSTATUS_PROBLEM_WITH_FILE = "problem_with_file"

#scope :without_feed, joins('left outer join authors_feeds on authors.id=authors_feeds.author_id').where('authors_feeds.feed_id is null')

  attr_accessible :asin, :title, :price, :rating, :copublished, :flagged, :book_status_id, 
        :author_ids, :publishing_right_ids, :publisher_id, :genre_id, :fiction_type_id, 
        :textbook_level_id, 
        :textbook_subject_id, :language_id, :level_ids, :comments, :authors_attributes, 
        :content_bucket_ids, :push_ids, :restricted, :limited

  has_and_belongs_to_many :levels
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :publishing_rights

  has_and_belongs_to_many :authors, :join_table => :authors_books
#  accepts_nested_attributes_for :authors
  
  has_many :pushes
  has_many :content_buckets, :through => :pushes
  has_many :associated_projects, :class_name => "Project"

  belongs_to :language
  belongs_to :genre
  belongs_to :fiction_type
  belongs_to :textbook_level
  belongs_to :textbook_subject
  belongs_to :book_status
  belongs_to :publisher #, :include => :origin
  belongs_to :origin, :include => :publisher

  has_one :continent, :through => :origin

  accepts_nested_attributes_for :genre, :publisher, :authors

  validates :title, :publisher_id, :language_id, :genre_id, :book_status_id, :presence => true

  # scope :African, do |books|
  #   books.publisher.origin.continent.where(:name => "Africa")
  # end
 #  where( :publisher => "Ghana" )#.continent.name.eql?("Africa"))


  class << self
    def not_pushed_to( project ) 
      @pid = Project.find_by_name(project)
      @books = Book.where( :project_id != @pid )
      return @books
   end

  def is_african
    if self.publisher.origin.continent.name.eql?("Africa") then
      return true
    else
      return false
    end
  end

   def African_count
      counter = 0
      Book.all.each do |book|
        if book.publisher && book.publisher.origin.continent.name.eql?("Africa") then
          counter +=1
        end
      end
      return counter
    end

    def Intl_count
      counter = 0
      Book.all.each do |book|
        if book.publisher && book.publisher.origin.continent.name.eql?("Africa") then
          counter +=1
        end
      end
      return (Book.all.count - counter)
    end
  
  end

end

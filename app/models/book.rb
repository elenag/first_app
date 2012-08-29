class Book < ActiveRecord::Base
  STATUS_WAITING_ON_PDF = 'waiting_on_pdf'
  STATUS_SENT_TO_CONVERT = 'sent_to_convert'
  STATUS_PROBLEM_WITH_PDF = 'problem_with_pdf'
  STATUS_PROBLEM_WITH_MOBI = 'problem_with_mobi'
  STATUS_WAITING_TO_BE_PUBLISHED =  'waiting_publishing' 
  STATUS_NA = 'N/A'
  STATUS_PUBLISHED_AMAZON = 'published_on_amazon'
  STATUS_OTHER = 'other'
  APPSTATUS_NA = 'app_N/A'
  APPSTATUS_PUBLISHED = 'published'
  APPSTATUS_WAITING_ON_FILE = 'app_waiting_on_file'
  APPSTATUS_WAITING_TO_PUBLISH = 'app_waiting_to_publish'
  APPSTATUS_PROBLEM_WITH_FILE = "problem_with_file"


  attr_accessible :asin, :title, :price, :rating, :copublished, :flagged, :status, :author_ids, 
        :publishing_right_ids, :publisher_id, :genre_id, :language_id, :level_ids,
        :comments, :authors_attributes, :content_bucket_ids, :push_ids, :restricted, :date_added,
        :appstatus, :limit

  has_and_belongs_to_many :levels
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :publishing_rights

  has_and_belongs_to_many :authors, :join_table => :authors_books
  accepts_nested_attributes_for :authors
  
  has_many :pushes
  has_many :content_buckets, :through => :pushes
  has_many :associated_projects, :class_name => "Project"

  belongs_to :language
  belongs_to :genre
  belongs_to :publisher, :include => :origin

  has_one :origin, :through => :publisher
  has_one :continent, :through => :origin


  # validates :status, :inclusion => { :in => [STATUS_OTHER, STATUS_PUBLISHED_APP, STATUS_PUBLISHED_AMAZON, STATUS_PUBLISHED_BOTH, STATUS_IN_REVIEW, STATUS_SENT_TO_CONVERT,
  #     STATUS_WAITING_PUBLISHING, STATUS_WAITING_PDF, STATUS_PROBLEM_WITH_MOBI, STATUS_PROBLEM_WITH_PDF], :message =>"You need to specify a book status" }
  validates :title, :status, :date_added, :publisher_id, :language_id, :genre_id, :author_ids, :presence => true

  #scope :publish, lambda { where :status => 'published' }

  class << self
    def books_status_collection
      {
        "Waiting on PDF" => STATUS_WAITING_ON_PDF,
        "Sent to convert" => STATUS_SENT_TO_CONVERT,
        "Problem with PDF" => STATUS_PROBLEM_WITH_PDF,
        "Problem with Mobi" => STATUS_PROBLEM_WITH_MOBI,
        "Awaiting publishing" => STATUS_WAITING_TO_BE_PUBLISHED,
        "NA" => STATUS_NA, 
        "Published on Amazon" => STATUS_PUBLISHED_AMAZON,
        "Other" => STATUS_OTHER
      }
    end

    def books_appstatus
      {
        "NA" => APPSTATUS_NA,
        "Waiting on file" => APPSTATUS_WAITING_ON_FILE,
        "Problem with file" => APPSTATUS_PROBLEM_WITH_FILE,
        "Waiting to be published" => APPSTATUS_WAITING_TO_PUBLISH, 
        "Published on app" => APPSTATUS_PUBLISHED
      }
    end
    
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
      @books = Book.all
      @bc = @books.count
      counter = 0
      @books.each do |book|
        if book.publisher.origin.continent.name.eql?("Africa") then
          counter +=1
        end
      end
      return counter
    end

    def Intl_count
      @books = Book.all
      @bc = @books.count
      counter = 0
      @books.each do |book|
        if not book.publisher.origin.continent.name.eql?("Africa") then
          counter +=1
        end
      end
      return counter
    end
  
  end

end

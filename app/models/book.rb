class Book < ActiveRecord::Base

#scope :without_feed, joins('left outer join authors_feeds on authors.id=authors_feeds.author_id').where('authors_feeds.feed_id is null')

  attr_accessible :asin, :title, :price, :rating, :copublished, :flagged, :book_status_id, 
        :author_ids, :publishing_right_ids, :publisher_id, :genre_id, :fiction_type_id, 
        :textbook_level_id, 
        :textbook_subject_id, :language_id, :level_ids, :comments, :authors_attributes, 
        :content_bucket_ids, :push_ids, :restricted, :limited, :description, :mou_fname, :origin_id,
        :epub, :mobi, :source_file, :source_cover, :fixed_epub

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
  belongs_to :fiction_type
  belongs_to :textbook_level
  belongs_to :textbook_subject
  belongs_to :book_status
  belongs_to :publisher #, :include => :origin
  belongs_to :origin

  has_one :continent, :through => :origin

  accepts_nested_attributes_for :genre, :publisher, :authors, :origin

  validates :title, :publisher_id, :language_id, :genre_id, :book_status_id, :presence => true
  validates_length_of :asin, :minimum => 10, :maximum => 10, :allow_blank => true
  validates_uniqueness_of :asin

   # scope :African, where(book.origin.continent.name => "Africa")
   # end
   #  scope :International do |book|
   #     book.origin.continent.where(:name => "Europe")
   #   end
#   scope :cero_balance, joins(:shipment).joins(:customer).where("customer_account_balance <> 0")
 #  scope :ToBeReviewed, joins(:book_status).where("book_status_name == Published")
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
      af_count = Book.count_by_sql("select count(*) from books b, origins o, continents c where c.name = '%s' and o.continent_id = c.id and b.origin_id = o.id" % ["Africa"])


      
      # Book.all.each do |book|
      #   if book.publisher && book.publisher.origin.continent.name.eql?("Africa") then
      #     counter +=1
      #   end
      # end
     #{} return counter
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

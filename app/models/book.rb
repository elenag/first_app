class Book < ActiveRecord::Base

#scope :without_feed, joins('left outer join authors_feeds on authors.id=authors_feeds.author_id').where('authors_feeds.feed_id is null')

  attr_accessible :asin, :title, :price, :rating, :copublished, :flagged, :book_status_id, 
        :origin_grade_ids, :author_ids, :publishing_right_ids, :publisher_id, :genre_id, :fiction_type_id, :read_level_id,
        :textbook_level_id, :textbook_sumlevel_id, :keywords, :category_id, :subcategory_id,
        :textbook_subject_id, :language_id, :level_ids, :comments, :authors_attributes, 
        :content_bucket_ids, :push_ids, :restricted, :limited, :description, :mou_fname, :origin_id,
        :epub, :mobi,  :source_file, :source_cover, :fixed_epub, :in_store, :binu_source_file_name,:binu_paperback_equivalent, :binu_sort_title, :binu_series, :binu_creator_1_name, :binu_creator_1_role, :binu_publisher, :binu_imprint, :binu_pub_date, :binu_srp_inc_vat, :binu_currency, :binu_on_sale_date, :binu_langauge, :binu_geo_rights, :binu_subject1, :binu_subject2, :binu_bisac, :binu_bic, :binu_bic2, :binu_fiction_subject2, :binu_keyword, :binu_short_description, :binu_not_for_sale, :binu_ready_for_sale, :binu_country,
        :certified_by_national_board_of_education,:book_id,:geo_restricted,:geo_restrictedby,:continent_ids, :origin_ids,:textguide_book_id,:pricingmodel

  has_and_belongs_to_many :levels, :join_table => :books_levels

  has_and_belongs_to_many :continents, :join_table => :restrictedcontinent_books,:association_foreign_key=>"geo_continent_id"
  accepts_nested_attributes_for :continents

  has_and_belongs_to_many :origins, :join_table => :restrictedorigin_books,:association_foreign_key=>"geo_origin_id"
  accepts_nested_attributes_for :origins

  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :publishing_rights

  has_and_belongs_to_many :authors, :join_table => :authors_books
  accepts_nested_attributes_for :authors


  has_many :pushes
  has_one  :textguide_books,:through =>:books, source: 'id'
  has_many :content_buckets, :through => :pushes
  has_many :associated_projects, :class_name => "Project"
  has_many :KdpReports
  has_many :projects, :through => :content_buckets
  has_many :purchase_orders, :through => :projects
  has_many :devices, :through => :purchase_orders


  belongs_to :book  
  belongs_to :language
  belongs_to :genre
  belongs_to :fiction_type
  belongs_to :category
  belongs_to :subcategory
  belongs_to :textbook_level
  belongs_to :textbook_sumlevel
  belongs_to :textbook_subject
  belongs_to :book_status
  belongs_to :publisher #, :include => :origin
  belongs_to :origin
  belongs_to :continent
  belongs_to :read_level

  has_one :continent, :through => :origin  


  has_many :order_items

  accepts_nested_attributes_for :genre, :publisher, :authors, :origin

  validates :title, :publisher_id, :language_id, :book_status_id, :presence => true
  #validates_length_of :asin, :minimum => 10, :maximum => 10, :allow_blank => true
  #validates_uniqueness_of :asin

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

    def self.search(query)    
   
      if query.blank?
         scoped
       else
        q = "%#{query}%"
        where("title like ? or asin like ? or keywords like ? or comments like ?", q, q, q , q)
      end
    end   

  end

end

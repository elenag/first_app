ActiveAdmin.register Book do

#scope lambda { where :status => 'published' }
scope :all, :default => true
scope :published do |books| 
    books.where( :status => 'published' )#:continent => 'Africa')
end
#scope :african do |books| 
#    books.all.where( :continent => 'Africa')
#end
#scope :international, where(:continent => nil)

filter :status, :as => :select, :collection => Book.books_status_collection
filter :genre
filter :language
filter :rating
filter :publisher
filter :price
filter :comments
filter :ASIN
filter :title
filter :authors
filter :date_added
filter :restricted, :as => :select
#filter :origin
filter :continent
#filter :not_pushed_to


  action_item :only => :index do
    	link_to 'Upload CSV', :action => 'upload_csv'
  	end

  	collection_action :upload_csv do
    	render "admin/csv/upload_csv"
  	end

  	collection_action :import_csv, :method => :post do
    	CsvDb.convert_save("book", params[:dump][:file])
    	redirect_to :action => :index, :notice => "CSV imported successfully!"
  	end


    index do
        column :status
        column("ASIN") do |book|
		    link_to book.asin, admin_book_path(book)
  		end
		column :title
		column "Author" do |book| 
			book.authors.map(&:name).join("<br />").html_safe
		end
        column :rating
        column :publisher
        column :continent
        column :genre
        column :restricted
        column "Levels" do |book| 
            book.levels.map(&:name).join("<br />").html_safe
        end
        column "Pushed to" do |book| 
            book.content_buckets.map(&:name).join("<br />").html_safe
        end

#        default_actions
    end


    form do |f|
    	f.inputs "Book Details" do
            f.input :status, :collection => Book.books_status_collection #, :as => :radio
    		f.input :asin
    		f.input :title
        	f.input :price
        	f.input :restricted
            f.input :flagged
            f.input :date_added
        	f.input :rating
        	f.input :copublished
            f.input :authors
            f.input :levels
            f.input :content_buckets
            f.input :publishing_rights
        	f.input :publisher, :collection => Publisher.all.map{ |publisher| [publisher.name, publisher.id] } 
            f.input :language , :collection => Language.all.map{ |language| [language.name, language.id] }
        	f.input :genre, :collection => Genre.all.map{ |genre| [genre.name, genre.id] }
        	f.input :comments
        end
        
        f.buttons

    end

end

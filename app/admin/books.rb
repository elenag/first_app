ActiveAdmin.register Book do

 #scope :African
 #scope :International
 #scope :ToBeReviewed

 batch_action :origins do |selection|
     Book.find(selection).each {|p| p.update_attribute(:origin_id, p.publisher.origin_id)}
     redirect_to collection_path, :notice => "country of origin changed!"
 end
# batch_action :waiting_on_pdf do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:status, 'waiting_on_pdf')}
#     redirect_to collection_path, :notice => "status changed to Waiting on PDF!"
# end
# batch_action :problem_with_pdf do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:status, 'problem_with_pdf')}
#     redirect_to collection_path, :notice => "status changed to problem_with_pdf!"
# end
# batch_action :sent_to_convert do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:status, 'sent_to_convert')}
#     redirect_to collection_path, :notice => "status changed to sent_to_convert!"
# end

# batch_action :problem_with_mobi do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:status, 'problem_with_mobi')}
#     redirect_to collection_path, :notice => "status changed to problem with mobi!"
# end
# batch_action :waiting_to_be_published do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:status, 'waiting_publishing')}
#     redirect_to collection_path, :notice => "status changed to awaiting publication!"
# end
# batch_action :published_on_amazon do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:status, 'published_on_amazon')}
#     redirect_to collection_path, :notice => "status changed to published on Amazon!"
# end
# batch_action :other do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:status, 'other')}
#     redirect_to collection_path, :notice => "status changed to other! Please, specify in the comments"
# end

# batch_action :APP_NA do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:appstatus, 'N/A')}
#     redirect_to collection_path, :notice => "status changed to N/A!"
# end
# batch_action :APP_WAITING_ON_FILE do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:appstatus, 'app_waiting_on_file')}
#     redirect_to collection_path, :notice => "status changed to app_waiting_on_file!"
# end
# batch_action :APP_PROBLEM_WITH_FILE do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:appstatus, 'problem_with_file')}
#     redirect_to collection_path, :notice => "status changed to problem_with_file!"
# end
# batch_action :APP_WAITING_TO_PUBLISH do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:appstatus, 'app_waiting_to_publish')}
#     redirect_to collection_path, :notice => "status changed to app_waiting_to_publish!"
# end
# batch_action :APP_PUBLISHED do |selection|
#     Book.find(selection).each {|p| p.update_attribute(:appstatus, 'published')}
#     redirect_to collection_path, :notice => "status changed to app_published!"
# end



filter :book_status
#filter :appstatus
filter :genre
filter :fiction_type
filter :textbook_level
filter :textbook_subject
filter :language
filter :levels
#filter :rating
filter :publisher
#filter :price
filter :comments
filter :asin
filter :title
filter :authors
filter :restricted, :as => :select
filter :publishing_rights
filter :origin #, :label => "Country", :collection => proc {Origin.all.map(&:name)}
filter :continent
filter :limited
filter :books_in_select_content_bucket, #_in_project_select, :as => :select, 
        :label => "Not Pushed To ", 
        :collection => proc { ContentBucket.all.map(&:name)}


  # controller do
  #   def create 
  #     create! do |format|
  #       format.html { redirect_to admin_books_url }
  #        create!(:notice => "Book has been created") { admin_books_url }
  #     end
  #   end
  # end


  action_item :only => :index do
    	link_to 'Upload CSV', :action => 'upload_csv'
  	end

  	collection_action :upload_csv do
    	render "admin/csv/upload_csv"
  	end

  	collection_action :import_csv, :method => :post do
    	CsvDb.convert_save_books(params[:dump][:file])
    	redirect_to :action => :index, :notice => "CSV imported successfully!"
  	end

  
    index do
      selectable_column
      column("Status") {|book| book.book_status.name } #, book.book_status.id] }  
      column :asin
		  column "Title" do |book|
        link_to book.title, admin_book_path(book)
      end
		  column "Author" do |book| 
			  link_to book.authors.map(&:name).join("<br />").html_safe, admin_author_path(book.authors)
		  end
        column :publisher, :sortable => false
        column :genre, :sortable => false
        column "Levels" do |book| 
            book.levels.map(&:name).join("<br />").html_safe
        end
        column :language, :sortable => false
        column :rating
    end

    csv do
        column("Status") { |book| book.book_status.name }
        column("ASIN")  { |book| book.asin }
        column("Title") { |book| book.title }
        column "Author" do |book| 
            book.authors.map(&:name).join(", ").html_safe
        end
        column("Publisher") { |book| book.publisher.name }
        column("Origin") do  |book| 
          if book.origin_id > 0 then
            book.origin.name
          end
        end
        column("Genre")     { |book| book.genre.name }
        column("Language")  { |book| book.language.name }
        column("Levels") do |book| 
            book.levels.map(&:name).join(", ").html_safe
        end
        column("Description")  { |book| book.description }
        column("Free Content") do |book| 
            book.publisher.free
        end
        column("Restrictions") { |book| book.restricted }
        column("Description")  { |book| book.description }
        column("MOU File Name"){ |book| book.mou_fname }
        column("Comments")     { |book| book.comments }

    end

    form do |f|
  #  	f.inputs "Authors Details" do 
  #       has_many :authors do |authors|
  #         authors.input :name

  # f.input :users, :as => :select, :input_html => { :size => 1}, 
  #       :multiple => false, collection: User.where(role:1), include_blank: false
  #       end
  #    end
       #, :collection => Author.all.map{ |stat| [stat.name, stat.id] }.sort
      f.inputs "Book Details" do 
       # f.input :authors, :as => :select, :input_html => { :size => 1}, collection: Author.all.sort
        f.input :authors, :as => :radio,  :collection => Author.all.sort_by(&:name) 
        #:as => :check_boxes, :collection => Author.order("name ASC").all
        f.input :asin, :input_html => { :size => 10 }
    		f.input :title, :input_html => { :size => 10 }
        f.input :book_status, :collection => BookStatus.all.map{ |stat| [stat.name, stat.id] }.sort
        f.input :language , :collection => Language.all.map{ |language| [language.name, language.id] }.sort
        f.input :genre, :collection => Genre.all.map{ |genre| [genre.name, genre.id] }.sort, :lable => "Content Type"
        f.input :fiction_type, :hint => "(Only if genre is fiction)", :collection => FictionType.all.map{ |stat| [stat.name, stat.id] }.sort
        f.input :textbook_level, :hint => "(Only if genre is textbook)", :collection => TextbookLevel.all.map{ |stat| [stat.name, stat.id] }.sort
        f.input :textbook_subject, :hint => "(Only if genre is textbook)", :collection => TextbookSubject.all.map{ |stat| [stat.name, stat.id] }.sort
        f.input :description
        f.input :mou_fname, :label => "MOU file name"
        f.input :levels
        f.input :rating
        f.input :source_file
        f.input :source_cover
        f.input :epub
        f.input :mobi
        f.input :fixed_epub, :label => "Fixed layout epub"
      end

      f.inputs "Publication Details" do
        f.input :publisher, :collection => Publisher.all.map{ |publisher| [publisher.name, publisher.id]}.sort
        f.input :copublished
        f.input :price
        f.input :restricted, :as => :boolean, :label =>"Rights restrictions", :hint => "(Specify in comments)"
        f.input :limited, :label =>"Copy restrictions", :hint => "(Number of copies to be pushed, following the MOU)"
        f.input :comments 
        f.input :origin
      end
      f.buttons
    end

end

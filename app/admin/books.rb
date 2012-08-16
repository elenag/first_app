ActiveAdmin.register Book do

batch_action :publish_amazon do |selection|
    Book.find(selection).each {|p| p.update_attribute(:status, 'publish_amazon')}
    redirect_to collection_path, :notice => "status changed to published!"
end
batch_action :publish_app do |selection|
    Book.find(selection).each {|p| p.update_attribute(:status, 'publish_app')}
    redirect_to collection_path, :notice => "status changed to published!"
end
batch_action :publish_both do |selection|
    Book.find(selection).each {|p| p.update_attribute(:status, 'publish_both')}
    redirect_to collection_path, :notice => "status changed to published!"
end
batch_action :waiting_pdf do |selection|
    Book.find(selection).each {|p| p.update_attribute(:status, 'waiting_pdf')}
    redirect_to collection_path, :notice => "status changed to Waiting PDF!"
end
batch_action :problem_pdf do |selection|
    Book.find(selection).each {|p| p.update_attribute(:status, 'problem_pdf')}
    redirect_to collection_path, :notice => "status changed to problem with PDF!"
end
batch_action :problem_mobi do |selection|
    Book.find(selection).each {|p| p.update_attribute(:status, 'problem_mobi')}
    redirect_to collection_path, :notice => "status changed to Problem with the MOBI file!"
end
batch_action :waiting_pub do |selection|
    Book.find(selection).each {|p| p.update_attribute(:status, 'waiting_pub')}
    redirect_to collection_path, :notice => "status changed to awaiting publication on Amazon!"
end
batch_action :other do |selection|
    Book.find(selection).each {|p| p.update_attribute(:status, 'other')}
    redirect_to collection_path, :notice => "status changed to other! Please, specify in the comments"
end


filter :status, :as => :select, :collection => Book.books_status_collection
filter :genre
filter :language
filter :levels
filter :rating
filter :publisher
filter :price
filter :comments
filter :ASIN
filter :title
filter :authors
filter :date_added
filter :restricted, :as => :select
filter :origin
filter :continent
filter :books_in_select_content_bucket, #_in_project_select, :as => :select, 
        :label => "Not Pushed To ", 
        :collection => proc { ContentBucket.all.map(&:name)}


  controller do
    def create 
      create! do |format|
        format.html { redirect_to admin_books_url }
         create!(:notice => "Book has been created") { admin_books_url }
      end
    end
  end


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
        selectable_column
        column("Status") {|book| status_tag(book.status) }
        column("ASIN") do |book|
           # link_to("Delete", admin_admin_user_path(admin_user), :method => :delete, :confirm => "Are you sure?") 
		    link_to book.asin, admin_book_path(book), :method => :edit
  		end
		column :title
		column "Author" do |book| 
			book.authors.map(&:name).join("<br />").html_safe
		end
        column :rating
        column :publisher
 #       column :continent
        column :genre
        column :restricted
        column "Levels" do |book| 
            book.levels.map(&:name).join("<br />").html_safe
        end
#        column "Pushed to" do |book| 
 #           book.content_buckets.map(&:name).join("<br />").html_safe
 #       end

        default_actions
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

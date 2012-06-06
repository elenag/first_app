ActiveAdmin.register Book do
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
        column("ASIN") do |book|
		    link_to book.asin, admin_book_path(book)
  		end
		column :title
		column "Author" do |book| 
			book.authors.map(&:name).join("<br />").html_safe
		end
        column :price
        column :rating
        column :publisher
        column :genre
        column "Levels" do |book| 
            book.levels.map(&:name).join("<br />").html_safe
        end

        default_actions
    end


    form do |f|
    	f.inputs "Book Details" do
    		f.input :asin
    		f.input :title
        	f.input :price
        	f.input :flagged
        	f.input :rating
        	f.input :copublished
            f.input :authors
            f.input :levels
            f.input :publishing_rights
        	f.input :publisher, :collection => Publisher.all.map{ |publisher| [publisher.name, publisher.id] } 
            f.input :language , :collection => Language.all.map{ |language| [language.name, language.id] }
        	f.input :genre, :collection => Genre.all.map{ |genre| [genre.name, genre.id] }
        	f.input :comments
        end
        
        f.buttons

    end

end

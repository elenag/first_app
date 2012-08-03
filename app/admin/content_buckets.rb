ActiveAdmin.register ContentBucket do
#	menu false

   batch_action :destroy

   index do
    	selectable_column
        id_column
        column :name
    #     column("ASIN") do |book|
		  #   link_to book.asin, admin_book_path(book)
  		# end
		column :project
		column "Books" do |content_bucket| 
			content_bucket.books.count
		end
       
        default_actions
   end


   show do 
   panel("ContentBucket details") do
     attributes_table_for content_bucket do 
      row :name
      row :project
      row('List of books') do |cb| 
        cb.books.map{ |book| book.title }.join("<br />").html_safe
      end  
    end
  end

  active_admin_comments
end


    form do |f|
    	f.inputs "ContentBucket Details" do
    		 f.input :name
    		 f.input :project
         f.has_many :pushes do |p|
            p.input :book #, :collection => Book.all.map{ |book| [book.title, book.id] } 
            p.input :push_date
 #           p.input :successful
         end

        end
        
        f.buttons

    end

  
end

ActiveAdmin.register ContentBucket do

  action_item :only => :show do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("Push", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  index do
  selectable_column
    id_column
    column :name
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
      f.buttons
    end

    f.inputs "Push Details" do
      f.has_many :pushes do |p|
        p.input :book #, :collection => Book.all.map{ |book| [book.title, book.id] } 
        p.input :push_date
        p.input :successful
        p.input :comments
      end
      f.buttons
    end   
    
  end
end


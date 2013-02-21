ActiveAdmin.register Publisher do
  menu :parent => "Books" 
  actions :index, :show, :new, :create, :update, :edit

  batch_action :destroy, false

  scope :contracts_end do |publishers|
    publishers.where('contract_end_date < ?', 1.week.from_now)
  end

  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end
  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end
  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("publishers", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end
  
  index do
    selectable_column
    column "Name" do |publisher|
        link_to publisher.name, admin_publisher_path(publisher)
      end
    column :origin, :sortable => false
    column :contract_end_date
    column :free
    default_actions
  end

  show do 
    panel("Publisher") do
      attributes_table_for publisher do 
        row :name 
        row :origin
        row :contract_end_date
        row :free
      end
    end

    panel("Publisher's Contact Info") do
      attributes_table_for publisher do 
        row :address
        row :telephone
        row :email
      end
    end

     panel("Contacts") do
       table_for publisher.pub_contacts do 
         column :name
         column :email
         column :telephone
         column :comments  
      end
    end

    panel("Publisher's Bank Info") do
      attributes_table_for publisher do 
        row :account_name
        row :account_number
        row :bank
        row :branch
        row :swift_code
        row :branch_code
        row :bank_code
        row :name_US_corresponding_bank
        row :routing_number
      end
    end

    panel("Books by Publisher") do
      table_for publisher.books do 
        column('List of books') do |b| 
          link_to b.title, admin_book_path(b) 
        end
        column('Authors') do |b| 
          b.authors.map(&:name).join("<br />").html_safe
        end    
      end
    end
  end



  form do |f|
    f.inputs "Publisher Details" do
      f.input :name
      f.input :origin
      f.input :contract_end_date
      f.input :free, :label => "Free Content", :as => :boolean
    end   

    f.inputs  "Publisher's Contact Info" do 
      f.input :address
      f.input :telephone
      f.input :email
    end

    f.inputs  "Publisher's Bank Info" do 
      f.input :account_name
      f.input :account_number
      f.input :bank
      f.input :branch
      f.input :swift_code
      f.input :branch_code
      f.input :bank_code
      f.input :name_US_corresponding_bank
      f.input :routing_number
    end

    f.inputs "Publisher's  Contacts" do 
      f.has_many :pub_contacts do |p|
        p.input :name
        p.input :email
        p.input :telephone
        p.input :comments
      end
    end

    f.buttons
  end

end

ActiveAdmin.register Author do
  menu :parent => "Books"

  batch_action :destroy, false
  
  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("authors", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  index do
    selectable_column
    column "Name", :sortable => :name do |author|
      link_to author.name, admin_author_path(author)
    end 
    column :origin, :sortable => false
    column "Books" do |author| 
      author.books.map{ |book| book.title }.join("<br />").html_safe
    end
    column :comments
  end

  show do
    attributes_table do
      row :name 
      row :origin
      row "Books" do |author| 
        author.books.map{ |book| book.title }.join("<br />").html_safe
      end
      row :comments
    end
  end

  form do |f|
    f.inputs "Author Details" do
      f.input :name
      f.input :origin, :collection => Origin.all.map{ |origin| [origin.name, origin.id] }
      f.input :comments
    end      
    f.buttons
  end


end

ActiveAdmin.register Category do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"
 
  index do
    column :name 
    default_actions
  end

  form do |f|
    f.inputs "Books Category Details" do
      f.input :name
      f.has_many :subcategories do |p|
        p.input :name
      end
    end
      f.buttons
    end
end

ActiveAdmin.register Subcategory do
    menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"
 
    index do
        column :name 
        column :category, :collection => Category.all.map{ |cat| [cat.name, cat.id] }
        default_actions
    end

    form do |f|
        f.inputs "Books Subcategory Details" do
            f.input :name
            f.input :category, :collection => Category.all.map{ |cat| [cat.name, cat.id] }
        end
        
        f.buttons
    end
end
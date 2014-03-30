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

  # Donated form render // form
  collection_action :donated_report do
      render "admin/csv/download_donated_report"
  end

  collection_action :download_donaterpt_action, :method => :post do
  
    yearofreport= (params[:dump]['start_date(1i)']).to_s
     @csvfilename = CsvDb.download_donaterpt_csv(
         
      Date.civil(
          params[:dump]['start_date(1i)'].to_i,
          params[:dump]['start_date(2i)'].to_i,
          params[:dump]['start_date(3i)'].to_i
      ).to_s,
      Date.civil(
          params[:dump]['end_date(1i)'].to_i,
          params[:dump]['end_date(2i)'].to_i,
          params[:dump]['end_date(3i)'].to_i
      ).to_s,      
      yearofreport

    )

    send_file Rails.root.to_s+"/csvdownload/"+@csvfilename, :type => "application/csv"    
  end 
  
  
  index do
    selectable_column
    column "Name", :sortable => true do |publisher|
        link_to publisher.name, admin_publisher_path(publisher)
      end
    column "Continent", :sortable => true do |publisher|
        publisher.origin.continent.name rescue nil
    end
    column "Country" ,:origin, :sortable => false
    column :contract_end_date
    column "Pricing model",:free

    default_actions
  end

  csv do
        column("Name")      { |pub| pub.name }
        column("Address")   { |pub| pub.address }
        column("Phone No")  { |pub| pub.telephone }
        column("Email")  { |pub| pub.email }
        column "Contacts Names" do |pub| 
            pub.pub_contacts.map(&:name).join(", ").html_safe
        end
        column "Contacts emails" do |pub| 
            pub.pub_contacts.map(&:email).join(", ").html_safe
        end
        column "Contacts Tel Numbers" do |pub| 
            pub.pub_contacts.map(&:telephone).join(", ").html_safe
        end
        column "Contacts Comments" do |pub| 
            pub.pub_contacts.map(&:telephone).join(", ").html_safe
        end
  end
  
  

  filter :name
  filter :continent, :include_blank => false, :as => :select, :label => "Region", 
        :collection => proc {Continent.all} rescue nil
  filter :origin_id, :collection => Origin.all.map{ |origin| [origin.name, origin.id]}.sort
  filter :created_at
  filter :updated_at
  filter :address
  filter :telephone
  filter :email
  filter :account_name
  filter :account_number
  filter :bank
  filter :branch
  filter :swift_code
  filter :branch_code
  filter :bank_code
  filter :name_US_corresponding_bank
  filter :routing_number
  filter :contract_end_date,:label=>"Ereader contract end date"
  filter :free, :label => "Ereader pricing Model",:collection =>[['Free','free'],['Mixed','mixed'],['Paid','paid']], :as => :select   
  filter :platform_mobile, :as => :boolean
  filter :platform_ereader, :as => :boolean
  filter :platform_mob_contractdate, :label => "Mobile Contract Date"



  show do 
    panel("Publisher") do
      attributes_table_for publisher do 
        row :name         
        row :origin
        row :contract_end_date,:label=>"Ereader contract end date"
        row("Ereader Pricing model") { publisher.free }
        row("Ereader Platform") { |publisher| publisher.platform_ereader rescue nil}
        row("Mobile Platform") { |publisher| publisher.platform_mobile rescue nil}
        row("Mobile Contract Date") { |publisher| publisher.platform_mob_contractdate rescue nil}

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
      f.input :self_published,:label=>"Self published"
      f.input :origin, :collection => Origin.all.map{ |origin| [origin.name, origin.id]}.sort
      f.input :contract_end_date,:label=>"Ereader contract end date", :as => :date 
      booleanoption = [['Free','free'],['Mixed','mixed'],['Paid','paid']]
      f.input :free, :label => "Ereader Pricing model",:collection =>booleanoption, :as => :radio          
       f.input :platform_ereader, :as => :boolean
      f.input :platform_mobile, :as => :boolean
      f.input :platform_mob_contractdate,:label=>"Mobile contract date", :as => :date
    end  

    # f.inputs  "Contract Details" do 
    #   f.input :imprints,:label=>"Imprints"      
    #   f.input :address,:label=>"Street Address"
    #   f.input :city
    #   f.input :postal_code
    #   f.input :country_id , :label => "Country", :collection => Origin.all.map{ |origin| [origin.name, origin.id]}.sort
    #   f.input :alernate_add1,:label=>"Alternate Address1"
    #   f.input :alernate_add2,:label=>"Alternate Address2"
    #   f.input :website
    #   f.input :shared_ftp_link,:label=>"Shared FTP Address"
    #   f.input :telephone
    #   f.input :email

    # end

    f.inputs  "Publisher's Contact Info" do 
      f.input :imprints,:label=>"Imprints"
      
      f.input :address,:label=>"Street Address"
      f.input :city
      f.input :postal_code
      # f.input :country_id , :label => "Country", :collection => Origin.all.map{ |origin| [origin.name, origin.id]}.sort
      f.input :alernate_add1,:label=>"Alternate Address1"
      f.input :alernate_add2,:label=>"Alternate Address2"
      f.input :website
      # f.input :shared_ftp_link,:label=>"Shared FTP Address"
      f.input :telephone
      f.input :email
    end

    f.inputs  "Publisher's Bank Info" do 
      f.input :account_name
      f.input :account_number
      f.input :bank
      f.input :branch
      f.input :swift_code
      # f.input :branch_code
      # f.input :bank_code
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

    f.actions
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
    f.actions
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
      f.actions
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
        
        f.actions
    end
end

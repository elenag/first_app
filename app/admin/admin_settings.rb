ActiveAdmin.register PublishingRight do
    menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"
 
    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Publishing Rights Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Language do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"

  actions :index, :show, :new, :create, :update, :edit

  index do
    column :name 
    column("Number of books") {|language| language.books.count}
    default_actions
  end

  show do 
    panel("Language") do
      attributes_table_for language do 
        row :name
        row("Number of books") {|language| language.books.count}
      end
    end
    panel("Books In Language") do
      table_for language.books do 
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
        f.inputs "Language Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Genre do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents" 

  actions :index, :show, :new, :create, :update, :edit

  index do
    column('Name') do |b| 
      link_to b.name, admin_genre_path(b) 
    end
    column("Number of books") {|genre| genre.books.count}
    default_actions
 end

  show do 
    panel("Genre") do
      attributes_table_for genre do 
        row :name
        row("Number of books") {|genre| genre.books.count}
      end
    end
    panel("Books In Genre") do
      table_for genre.books do 
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
        f.inputs "Genre Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register FictionType do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents" 

  actions :index, :show, :new, :create, :update, :edit
  index do
    column :name 
    column("Number of books") {|ft| ft.books.count}
    default_actions
  end

  show do 
    panel("Fiction Type") do
      attributes_table_for fiction_type do 
        row :name
        row("Number of books") {|ft| ft.books.count}
      end
    end
    panel("Books In Fiction Type") do
      table_for fiction_type.books do 
        column('List of books') do |b| 
          link_to b.title, admin_book_path(b) 
        end
        column('Authors') do |b| 
          b.authors.map(&:name).join("<br />").html_safe
        end  
        # column('Country') do |b|
        #   b.origin.name
        # end  
      end
    end
  end

    form do |f|
        f.inputs "Fiction Type Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register TextbookLevel do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents" 

  actions :index, :show, :new, :create, :update, :edit

  index do
    column :name 
    column("Number of books") {|tl| tl.books.count}
    default_actions
  end

  form do |f|
    f.inputs "Textbook Level Details" do
      f.input :name
    end
        
    f.buttons
  end
end

ActiveAdmin.register TextbookSumlevel do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents" 

  actions :index, :show, :new, :create, :update, :edit

  index do
    column :name 
    column("Number of books") {|tl| tl.books.count}
    default_actions
  end

  form do |f|
    f.inputs "Textbook Level Details" do
      f.input :name
    end
        
    f.buttons
  end
end

ActiveAdmin.register TextbookSubject do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents" 

  actions :index, :show, :new, :create, :update, :edit

  index do
    column :name 
    column("Number of books") {|ts| ts.books.count}
    default_actions
  end

  show do 
    panel("Textbook Subject") do
      attributes_table_for textbook_subject do 
        row :name
        row("Number of books") {|ts| ts.books.count}
      end
    end
    panel("Books In Subject") do
      table_for textbook_subject.books do 
        column('List of books') do |b| 
          link_to b.title, admin_book_path(b) 
        end
        column('Authors') do |b| 
          b.authors.map(&:name).join("<br />").html_safe
        end  
        column('Country') do |b|
          b.origin.name rescue nil
        end  
      end
    end
  end

    form do |f|
        f.inputs "Textbook Subject Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register BookStatus do
    menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"
    actions :index, :show, :new, :create, :update, :edit
end

ActiveAdmin.register Appstatus do
    menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"
    actions :index, :show, :new, :create, :update, :edit
end

ActiveAdmin.register Platform do
    menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents" 
    actions :index, :show, :new, :create, :update, :edit

    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Platform Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register ReadLevel do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"
  actions :index, :show, :new, :create, :update, :edit

  index do
    column :name 
    column("Number of books") {|l| l.books.count}
    default_actions
  end

  form do |f|
    f.inputs "Level Details" do
      f.input :name
    end
        
    f.buttons
  end
end

ActiveAdmin.register DeviceType do
    menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"

    actions :index, :show, :new, :create, :update, :edit
    
    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Device Types Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Origin do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"

  actions :index, :show, :new, :create, :update, :edit

  index do
    column :name
    column :continent
    default_actions
  end

end

ActiveAdmin.register ProjectType do
  menu :if => proc{ current_admin_user.can_edit_origins? }, :parent => "Continents"

  actions :index, :show, :new, :create, :update, :edit

  index do
    column :name
    default_actions
  end

end

ActiveAdmin.register Continent do
  menu :if => proc{ current_admin_user.can_edit_origins? }

  actions :index, :show, :new, :create, :update, :edit

  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("Continent", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end
  
  index do
    selectable_column
    column :name
    default_actions
  end

end

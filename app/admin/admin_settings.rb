ActiveAdmin.register PublishingRight do
    menu :if => proc{ current_admin_user.can_edit_origins? }
 
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
    menu :if => proc{ current_admin_user.can_edit_origins? }
    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Language Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Genre do
    menu :if => proc{ current_admin_user.can_edit_origins? } 

    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Genre Details" do
            f.input :name
        end
        
        f.buttons
    end
end

ActiveAdmin.register Platform do
    menu :if => proc{ current_admin_user.can_edit_origins? } 

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

ActiveAdmin.register Level do
   menu :if => proc{ current_admin_user.can_edit_origins? }

    index do
        column :name 
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
    menu :if => proc{ current_admin_user.can_edit_origins? }
    
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
  menu :if => proc{ current_admin_user.can_edit_origins? }

  index do
    column :name
    column :continent
    default_actions
  end

end

ActiveAdmin.register ProjectType do
  menu :if => proc{ current_admin_user.can_edit_origins? }

  index do
    column :name
    default_actions
  end

end

ActiveAdmin.register Continent do
  menu :if => proc{ current_admin_user.can_edit_origins? }

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

ActiveAdmin.register AdminUser do #, :as => "Users" do
  filter :email
  filter :last_sign_in_at
  
  index do
    column :id
    column :email
    column :can_edit_origins
    column "Last Sign in", :last_sign_in_at
    column ("Actions") do |admin_user|
       delete = " | " + link_to("Delete", admin_admin_user_path(admin_user), :method => :delete, :confirm => "Are you sure?") unless current_admin_user == admin_user
      
       link_to("Details", admin_admin_user_path(admin_user)) + " | " + \
      link_to("Edit", edit_admin_admin_user_path(admin_user)) + delete.try(:html_safe)
    end
    #default_actions
  end

  show :title => :email do 
    panel "User Details" do
      attributes_table_for admin_user do
       row :email
       row :last_sign_in_at
       row :created_at
       row :can_edit_origins
      end
    end
  end

  
  form do |f|
    f.inputs do
      f.input :email
      f.input :password, :type => :password
      f.input :password_confirmation, :type => :password
      f.input :can_edit_origins
    end
    
    f.buttons
  end
end

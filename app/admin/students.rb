ActiveAdmin.register Student do
  menu :if => proc{ current_admin_user.DR_rel? or current_admin_user.can_edit_origins?}

  scope :all, :default => true


  filter :first_name
  filter :other_names
  filter :role
  filter :account
  filter :school, :as => :select, :label => "School", 
        :collection => proc {School.all} rescue nil
  filter :homeroom, :as => :select, :label => "Classroom", 
        :collection => proc {Homeroom.all} rescue nil

  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("students", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  
  index  do |student|
    selectable_column
    column :first_name
    column :other_names
    column :role
    column :homeroom
    column('Content Bucket') do |student| 
      student.content_buckets.map{ |content_bucket| content_bucket.name }.join("<br />").html_safe
    end  
    default_actions
  end


  form do |f|
    f.inputs "Students Details" do
      f.input :first_name
      f.input :other_names
      f.input :role, :collection =>  Student.students_roles_collection
   #   f.input :homeroom
      f.input :account
    end
    f.buttons
  end

  show do 
    panel("Students details") do
      attributes_table_for student do 
        row :first_name
        row :other_names
        row :role
        row :homeroom
        row :school
      end
    end
    panel("Books Pushed") do
      table_for student.books do 
        column('List of books') do |b| 
          b.title 
        end
        column('Authors') do |b| 
          b.authors.map(&:name).join("<br />").html_safe
        end    
      end
    end
  end

end



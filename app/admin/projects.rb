ActiveAdmin.register Project do
 

  filter :name, :html => "class='hoge'"
  filter :origin
  filter :model, :as => :check_boxes

  index  do |project|
    column :name do |project|
      link_to project.name, admin_project_path(project)
    end
    column('Origin') { |project| project.origin.name }
    column :model
    column :target_size
    column :current_size
    column('Devices #') { |project| project.devices_active }
    column('Students with Devices') {}
  end

  scope :all, :default => true
 

form do |f|
    f.inputs "Project Details" do
      f.input :name
      f.input :origin
      f.input :model
      f.input :target_size
      f.input :current_size
      f.has_many :schools do |p|
        p.input :name
      end
      f.buttons
    end
end

show do 
  panel("Project details") do
    attributes_table_for project do 
      row :name
      row :origin
      row :model
      row "# Classes" do
        project.homerooms.count
      end
    end
  end

  active_admin_comments
end

end



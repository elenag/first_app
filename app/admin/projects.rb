ActiveAdmin.register Project do
 
  batch_action false

 # @pt_kits = ProjectType.find_by_name('Kits')
#  @pt_id_lp = ProjectType.search_lp
  scope :all, :default => true
#  scope :kits

  filter :name, :html => "class='hoge'"
  filter :origin
  filter :model, :as => :check_boxes
  filter :project_type, :as => :check_boxes

  index  do |project|
    column :name do |project|
      link_to project.name, admin_project_path(project)
    end
    column('Origin') { |project| project.origin.name }
    column :model
    column :project_type
    column :target_size
    column :current_size
    column('Devices #') { |project| project.devices_active }
    column('Students with Devices') {}
    column('Content Buckets') do |project| 
       project.content_buckets.map(&:name).join("<br />").html_safe
    end
  end


  show do 
    h2 project.name 

    panel "Project Data" do
      attributes_table_for project do
        row :name
        row :origin
        row :model
        row :project_type
        row :target_size
        row :current_size
  #      row("Number of devices")
      end
    end

    panel "School" do
      table_for project.schools do
        column "name" do |school|
          link_to school.name, admin_school_path(school)
        end
        column "homerooms" do |h|
          link_to h.homerooms.map(&:name).join("<br />").html_safe
        end
        column "number of pupils" do |p|
          p.homerooms.count
        end
      end
    end
    

    panel "Content Buckets" do
      table_for project.content_buckets do
        column "name" do |content_bucket|
          link_to content_bucket.name, admin_content_bucket_path(content_bucket)
        end
        column "books" do |books|

        end
      end
    end
  end
 
  # active_admin_comments


  # sidebar "Content Buckets", :only => :show do
  #   @cb = Project.projects_CB
  #   section "STATISTICS" do
  #   div :class => "attributes_table" do
  #     table do
  #       tr do
  #         th "Total Number of Devices"
  #           td number_with_delimiter(Device.where(:status => Device::STATUS_OK).count)
  #  #         li link_to(project.name, admin_project_path(project))
  #  #       end
  #       end


  #    table_for project.content_buckets  do |t|
  #       t.column("") do |project|
  #          project.content_buckets.map(&:name).join("<br />").html_safe  
  #       end
  #     #  t.column { |project| link_to project.content_buckets.first, admin_content_bucket_path(project.content_buckets.first) }
  #    end
 
 

form do |f|
    f.inputs "Project Details" do
      f.input :name
      f.input :origin
      f.input :model
      f.input :project_type
      f.input :target_size
      f.input :current_size
      f.has_many :schools do |p|
        p.input :name
      end
      f.has_many :content_buckets do |p|
        p.input :name
      end
      f.buttons
    end
end

# show do 
#   panel("Project details") do
#     attributes_table_for project do 
#       row :name
#       row :origin
#       row :model
#       row :project_type
#       row "# Classes" do
#         project.homerooms.count
#       end
#     end
#   end

#   active_admin_comments
# end

end



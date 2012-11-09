ActiveAdmin.register School do
  menu :if => proc{ current_admin_user.ops_rel? or current_admin_user.can_edit_origins? }, :parent => "Projects"
  filter :name, :html => "class='hoge'"
  filter :origin

  index  do |school|
    selectable_column
    column :name do |school|
      link_to school.name, admin_school_path(school)
    end
    column("Project" ) { |school| school.project.name }
    column("Classrooms") do |school|
      link_to school.homerooms.map(&:name).join("<br />").html_safe, admin_homeroom_path(school.homerooms)
    end
#{|school| homeroom.accounts.where(:status => 'active').count}
    default_actions
  end

  form do |f|
    f.inputs "School Details" do
      f.input :name
      f.input :project
      f.has_many :homerooms do |p|
        p.input :name
      end
    end
    f.actions
  end


  show do  
    panel "School" do
      table_for school.homerooms.each do
        column "Classrroms" do |homeroom|
          link_to homeroom.name, admin_homeroom_path(homeroom)
        end
        column "Number of active accounts" do |homeroom|
           homeroom.accounts.where(:status => 'active').count 
        end
        # column "number of devices" do |homeroom|
        #   homeroom.accounts_without_devices
        # end
      end
    end
    

    # panel "Content Buckets" do
    #   table_for project.content_buckets do
    #     column "name" do |content_bucket|
    #       link_to content_bucket.name, admin_content_bucket_path(content_bucket)
    #     end
    #     column "books" do |cb|
    #       cb.books.map{ |book| book.title }.join("<br />").html_safe
    #     end
    #   end
    # end
  end


end
    
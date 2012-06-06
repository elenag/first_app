ActiveAdmin::Dashboards.build do


section "STATISTICS" do
    div :class => "attributes_table" do
      table do
        tr do
          th "Total Number of Devices"
            td number_with_delimiter(Device.where(:status => Device::STATUS_OK).count)
   #         li link_to(project.name, admin_project_path(project))
   #       end
        end
        tr do
          th "Devices Delivered This Month"
          td number_with_delimiter(Device.this_month.where(:status => Device::STATUS_OK).count)
        end

        tr do
          th "Total Number of  African Books"
   #       td number_with_delimiter(Devices.)
   #td number_with_delimiter(Invoice.this_month.where(:status => Invoice::STATUS_PAID).count)
   #         li link_to(project.name, admin_project_path(project))
   #       end
        end
        tr do
          th "Total Number of  International Books"
   #       td number_with_delimiter(Devices.)
   #         li link_to(project.name, admin_project_path(project))
   #       end
        end
    
        tr do
          th "Books Delivered This Month"
   #       td number_to_currency(Invoice.this_month.where(:status => Invoice::STATUS_PAID).all.sum(&:total)), :style => "font-weight: bold;"
        end
      end
    end
  end

section "DEVICES" do
    table_for Project.order('created_at desc').all do |t|
      t.column("Name") { |project| link_to project.name, admin_project_path(project) }
      t.column("Country") { |project| project.origin.name }
      t.column("Model") { |project| project.model.name }
      t.column("Current Size") { |project| project.current_size }
      t.column("Target Size") { |project| project.target_size }
      t.column("Devices Teachers") { |project| project.schools.all.count }
      t.column("Devices Students") { |project| project.total_classes }
      t.column("Out of Order") { |project| project.accounts_active }


    end
  end
#section "Projects" do
#  ul do
#    Project.all.collect do |project|
 #     li link_to(project.name, admin_project_path(project))
 #   end
 # end




  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }



end
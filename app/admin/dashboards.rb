ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1

    content :title => proc{ I18n.t("active_admin.dashboard") } do
   
      columns do

      column do
        panel "WELCOME" do
          div do
            render('admin/sidebar_links', :model => 'dashboards')
          end
        end
      end

    end

      columns do

      column do
        panel "PROJECTS" do
          table_for Project.order('created_at desc').each do |project|#.name.order('id desc').limit(5) do
            column("Name")                {|project| link_to(project.name, admin_project_path(project)) }
            column("Country")             { |project| project.origin.name }
            column("Model")               { |project| project.model.name }
            column("Type")                { |project| project.project_type.name }
            column("Number of Devices")   {|project| project.number_devices }                                    
            column("Out of Order")        { |project| project.out_of_order }
          end
        end
      end

      column do
        panel "Books" do
          table_for Book.where(:book_status_id => 7).limit(10) do |book| #.name.order('id desc').limit(5) do
            column("Latest Titles")       {|book| link_to(book.title, admin_book_path(book)) }
          end
        end
      end
    end


  end
end

#columns do

  # column do
  #   panel "STATISTICS" do
  #     table  do#_for Order.complete.order('id desc').limit(10) do
  #       tr do
  #         th "Total Number of Devices"
  #         td number_with_delimiter(Device.where(:status => 'ok').count + Device.where(:status => 'spare').count)
  #        end
  #       tr do
  #         th "Broken Devices"
  #         td number_with_delimiter(Project.sum {|p| p.out_of_order })
  #       end

  #       tr do
  #         th "Total Number of  African Books"
  #         td number_with_delimiter(Book.African_count)
  #       end
  #       tr do
  #         th "Total Number of  International Books"
  #         td number_with_delimiter(Book.Intl_count)
  #       end
    
  #       tr do
  #         th "Books Delivered This Month"
  #         td number_with_delimiter(Push.this_month.count)
  #       end

  #       # column("State")   {|order| status_tag(order.state)                                    } 
  #       # column("Customer"){|order| link_to(order.user.email, admin_customer_path(order.user)) } 
  #       # column("Total")   {|order| number_to_currency order.total_price                       } 
  #     end
  #   end
  # end

# section "STATISTICS" do
#     div :class => "attributes_table" do
#       table do
#         tr do
#           th "Total Number of Devices"
#           td number_with_delimiter(Device.where(:status => 'ok').count + Device.where(:status => 'spare').count)
#          end
#         tr do
#           th "Broken Devices"
#           td number_with_delimiter(Project.sum {|p| p.out_of_order })
#         end

#         tr do
#           th "Total Number of  African Books"
#           td number_with_delimiter(Book.African_count)
#         end
#         tr do
#           th "Total Number of  International Books"
#           td number_with_delimiter(Book.Intl_count)
#         end
    
#         tr do
#           th "Books Delivered This Month"
#           td number_with_delimiter(Push.this_month.count)
#         end
#       end
#     end
#   end

 # column do
 #    panel "STATISTICS" do
 #    table_for Project.order('created_at desc').all do |project|
 #      column("Name") { |project| link_to project.name, admin_project_path(project) }
 #      column("Country") { |project| project.origin.name }
 #      column("Model") { |project| project.model.name }
 #  #    column("Current Size") { |project| project.current_size }
 #  #    column("Target Size") { |project| project.target_size }
 #  #    column("Devices Teachers") { |project| project.others_with_devices }
 #  #    column("Devices Students") { |project| project.students_with_devices }
 #      column("Out of Order") { |project| project.out_of_order }
 #     end
 #   end
 # end

 # column do
 #    panel "Book Order Tool" do
 #      div do
 #        render('_sidebar_links', :model => 'dashboards')
 #      end

 #      div do
 #        render('/admin/_sidebar_links', :model => 'dashboards')
 #      end
 #    end
 #  end

 # end
#end
  
  # link_to 'Book Order Tool', :action => 'redirect_to_bot'
  

  # collection_action :redirect_to_bot do
  #   render "order/review"
  # end

#end


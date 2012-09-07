ActiveAdmin::Dashboards.build do


section "STATISTICS" do
    div :class => "attributes_table" do
      table do
        tr do
          th "Total Number of Devices"
          td number_with_delimiter(Device.where(:status => 'ok').count + Device.where(:status => 'spare').count)
         end
        tr do
          th "Devices Out of Order"
          td number_with_delimiter(Project.sum {|p| p.out_of_order })
        end

        tr do
          th "Total Number of  African Books"
          td number_with_delimiter(Book.African_count)
        end
        tr do
          th "Total Number of  International Books"
          td number_with_delimiter(Book.Intl_count)
        end
    
        tr do
          th "Books Delivered This Month"
          td number_with_delimiter(Push.this_month.count)
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
      t.column("Devices Teachers") { |project| project.others_with_devices }
      t.column("Devices Students") { |project| project.students_with_devices }
      t.column("Out of Order") { |project| project.out_of_order }
    end
  end

end
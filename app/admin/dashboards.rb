ActiveAdmin::Dashboards.build do


section "STATISTICS" do
    div :class => "attributes_table" do
      table do
        tr do
          th "Total Number of Devices"
            td number_with_delimiter(Device.where(:status => 'ok').count)
   #         li link_to(project.name, admin_project_path(project))
   #       end
        end
        tr do
          th "Devices Delivered This Month"
          td number_with_delimiter(Event.this_month.where(:name => 'assigned').count)
        end

        tr do
          th "Total Number of  African Books"
   #       td number_with_delimiter(Devices.)
   #td number_with_delimiter(Invoice.this_month.where(:status => Invoice::STATUS_PAID).count)
   #         li link_to(project.name, admin_project_path(project))
   #        end
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
      t.column("Devices Students") { |project| project.devices_active }
      t.column("Out of Order") { |project| project.accounts_active }
    end
  end

end
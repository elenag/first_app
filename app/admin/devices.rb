ActiveAdmin.register Device do
  menu :if => proc{ current_admin_user.ops_rel? or current_admin_user.DR_rel? }

  scope :OK, :default => :true
  scope :BROKEN
  scope :SPARE
  scope :TO_REPAIR
  scope :TO_RETURN


  batch_action :assign, :priority => 2 do |selection|
    Device.find(selection).each {|device| device.new_event('assigned')}
    redirect_to collection_path, :alert => "The selected devices have been assigned!"
  end

  batch_action :broken, :priority => 1 do |selection|
    Device.find(selection).each {|device| device.new_event('broken')}
    redirect_to collection_path, :notice => "The selected devices have been set to BROKEN!"
  end

  batch_action :missing, :priority => 5 do |selection|
    Device.find(selection).each {|device| device.new_event('missing')}
    redirect_to collection_path, :notice => "The selected devices have been set to MISSING!"
  end

  batch_action :returned, :priority => 3 do |selection|
    Device.find(selection).each {|device| device.new_event('returned')}
    redirect_to collection_path, :notice => "The selected devices have been set to RETURNED!"
  end

  batch_action :repaired, :priority => 4 do |selection|
    Device.find(selection).each {|device| device.new_event('repaired')}
    redirect_to collection_path, :notice => "The selected devices have been set to REPAIRED!"
  end

  batch_action :disposed, :priority => 6 do |selection|
    Device.find(selection).each {|device| device.new_event('disposed')}
    redirect_to collection_path, :notice => "The selected devices have been DISPOSED!"
  end

  batch_action :Reason_to_return_broken_screen , :priority => 7 do |selection|
    Device.find(selection).each {|device| device.update_attribute(:return_reason, 'broken_screen')}
    redirect_to collection_path, :notice => "The return reason has been set to BROKEN SCREEN!"
  end

  batch_action :Reason_to_return_frozen_screen, :priority => 8 do |selection|
    Device.find(selection).each {|device| device.update_attribute(:return_reason,'frozen_screen')}
    redirect_to collection_path, :notice =>  "The return reason has been set to FROZEN SCREEN!"
  end

  batch_action :Reason_to_return_connectivity_problem, :priority => 9 do |selection|
    Device.find(selection).each {|device| device.update_attribute(:return_reason,'connectivity_problem')}
    redirect_to collection_path, :notice => "The return reason has been set to CONNECTIVITY PROBLEMS!"
  end

  batch_action :Reason_to_return_loose_contact, :priority => 10 do |selection|
    Device.find(selection).each {|device| device.update_attribute(:return_reason,'loose_contact')}
    redirect_to collection_path, :notice => "The return reason has been set to LOOSE CONTACT!"
  end


    filter :project, :include_blank => false, :as => :select, :label => "Project", 
        :collection => proc {Project.all} rescue nil
    filter :school, :as => :select, :label => "School", 
        :collection => proc {School.all} rescue nil
    filter :homeroom
    filter :device_type
    filter :account #, :as => :select, :label => "Account", 
        #:collection => proc {Account.all.where(:id => :account_id)} rescue nil
    filter :control
    filter :flagged
    filter :serial_number
    filter :status#, :as =>select, :label => "Status", :collection => proc {Device.all} rescue nil
    filter :event
    filter :reinforced_screen
    filter :purchase_order, :as => :select, :label => "Purchase Order", 
        :collection => proc {PurchaseOrder.all.map(&:po_number)} rescue nil
    filter :number_broken
    filter :action, :as =>:select, :collection => Device.device_action_collection

	  action_item :only => :index do
    	link_to 'Upload CSV', :action => 'upload_csv'
  	end

  	collection_action :upload_csv do
    	render "admin/csv/upload_csv"
  	end

  	collection_action :import_csv, :method => :post do
    	CsvDb.convert_save("device", params[:dump][:file])
    	redirect_to :action => :index, :notice => "CSV imported successfully!"
  	end


    index do
         selectable_column
         column("Account") { |device| device.account.acc_number rescue nil}
         column "Surname" do |device| 
             device.account.students.map(&:other_names).join("<br />").html_safe rescue nil
         end
         column "Name" do |device| 
             device.account.students.map(&:first_name).join("<br />").html_safe rescue nil
         end
         column :serial_number do |device|
             link_to device.serial_number, admin_device_path(device), :action => :edit
         end
         column :device_type
         column ("Status") { |device| status_tag(device.status) }
         column('Reinforced') { |device| device.reinforced_screen }
         column("Comments") { |device| device.account.comments rescue nil}
         column("Broken devices") { |device| device.account.number_broken rescue nil}
    end

    csv do
        column("Account") do |device|
          device.account.acc_number
        end
        column "Surname" do |device| 
            device.account.students.map(&:other_names).join(", ")
        end
        column "Name" do |device| 
            device.account.students.map(&:first_name).join(", ")
        end
        column("SerialNumber") {|device| device.serial_number }
        column("Type") { |device| device.device_type.name }
        column("Status") { |device| device.status }
        column('Reinforced') { |device| device.reinforced_screen }
        column("Comments") { |device| device.account.comments }
        column("Broken") { |device| device.account.number_broken }
    end

    form do |f|
    	f.inputs "Device Details" do
        	f.input :serial_number
        	f.input :flagged
        	f.input :control
        	f.input :reinforced_screen
          f.input :account, :collection => Account.all.map{ |account| [account.acc_number, account.id] }
        	f.input :purchase_order, :collection => PurchaseOrder.all.map{ |po| [po.po_number, po.id] }
          f.input :status, :collection => Device.device_status_collection 
          f.input :device_type, :collection => DeviceType.all 
          f.input :action, :collection => Device.device_action_collection

        end
        
        f.actions

    end

  
end





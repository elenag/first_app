ActiveAdmin.register Device do

    filter :project, :as => :select, :label => "Project", 
        :collection => proc {Project.all} rescue nil
    filter :school, :as => :select, :label => "School", 
        :collection => proc {School.all} rescue nil
    filter :homeroom, :as => :select, :label => "Classroom", 
        :collection => proc {Homeroom.all} rescue nil


#    filter :location_id, :as => :select, :label => "UnSale location", 
#         :collection => proc { Location.where(:sale => true) } rescue nil



#    filter :status, :collection => Device.status_collection, :as =>:radio
    filter :serial_number

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
        column("Account") do |device|
            link_to device.account.acc_number, admin_device_path(device)
        end
 #       column("Account") { |device| device.account.acc_number } 
        column "Surname" do |device| 
            device.account.students.map(&:other_names).join("<br />").html_safe
        end
        column "Name" do |device| 
            device.account.students.map(&:first_name).join("<br />").html_safe
        end
        column :serial_number
        column :control
        column ("Status") { |device| device.status }
        column('Reinforced') { |device| device.reinforced_screen }
        column("Comments") { |device| device.account.comments }
        column("Broken devices") { |device| device.account.number_broken }

        
#        column :

#        column :device_type
#        column :purchase_order
#        column('Last Event') {|device| device.last_event }


#        default_actions
    end


    form do |f|
    	f.inputs "Device Details" do
        	f.input :serial_number
        	f.input :flagged
        	f.input :control
        	f.input :reinforced_screen
        	f.input :device_type
            f.input :account, :collection => Account.all.map{ |account| [account.acc_number, account.id] }
        	f.input :purchase_order
            f.input :status, :collection => Device.status_collection, :as => :radio
 #           f.input :event, :collection => Event.events_name_collection
        end
        
        f.buttons

    end

  
end


ActiveAdmin.register PurchaseOrder do
    index do
        column :po_number
        column :date_ordered
        column :date_received

        default_actions
    end


end
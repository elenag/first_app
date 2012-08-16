ActiveAdmin.register PurchaseOrder do
    menu :if => proc{ current_admin_user.ops_rel? }, :parent => "Devices"

    action_item :only => :view do
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
        column :po_number
        column :date_ordered
        column :warranty_end_date
        column :project
        column :comments

        default_actions
    end
end


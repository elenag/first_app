ActiveAdmin.register DeviceType do
	menu false
	
    index do
        column :name 
        default_actions
    end

    form do |f|
        f.inputs "Device Types Details" do
            f.input :name
        end
        
        f.buttons
    end
end

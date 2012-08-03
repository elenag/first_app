ActiveAdmin.register PurchaseOrder do
    menu :if => proc{ current_admin_user.ops_rel? }
    index do
        column :po_number
        column :date_ordered
        column :warranty_end_date
        column :project
        column :comments

        default_actions
    end
end


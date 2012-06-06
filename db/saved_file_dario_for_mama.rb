rails generate active_admin:resource AdminUser


#in the app/admin/admin_users.rb add:

ActiveAdmin.register AdminUser do
  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end
end


# Generate the model
rails generate model Project
ActiveAdmin.register Origin do
 # menu :if => proc{ current_admin_user.can_edit_origins? }
  menu false

  index do
    column :name
    column :continent
    default_actions
  end

end

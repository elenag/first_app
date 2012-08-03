ActiveAdmin.register School do
  menu :if => proc{ current_admin_user.ops_rel? or current_admin_user.can_edit_origins? }
  filter :name, :html => "class='hoge'"
  filter :origin

  index  do |school|
    column :name do |school|
      link_to school.name, admin_school_path(school)
    end
  end

form do |f|
  f.inputs "School Details" do
    f.input :name
    f.input :project
    f.has_many :homerooms do |p|
      p.input :name
    end
  end
  f.actions
end

end
    
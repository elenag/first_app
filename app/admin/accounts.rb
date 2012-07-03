ActiveAdmin.register Homeroom do

  menu false

  index do
    column :name
    column "Content Bucket" do |homeroom| 
      homeroom.content_buckets.map(&:name).join("<br />").html_safe
    end
    column "Accounts" do |homeroom| 
        homeroom.accounts.map(&:acc_number).join("<br />").html_safe
    end
    default_actions
  end


  show do 
    panel("Classroom details") do
      attributes_table_for homeroom do 
        row :name
#        row :model
#        row("List of Accounts") do |homeroom|
 #         link_to homeroom.accounts.students.first_name, admin_accounts_path(homeroom.accounts.students.all) 
 #       end 
   #     row("Number of devices") homeroom.accounts.devices
      end
    end
  end

  form do |f|
    f.inputs "Homeroom Details" do
      f.input :name
      f.input :school
      f.input :content_buckets
      f.has_many :accounts do |acc|
        acc.inputs
      end
    end
  f.buttons

  end


end



ActiveAdmin.register Account do
  menu false
 
  index do
      column :acc_number
      column :status
#      column :Student
#      column('Student') { |account| account.students.show_student }
#      column("Device No") account.device_id.serial_number

      default_actions
  end

  form do |f|
    f.inputs "Account Details" do
      f.input :acc_number
      f.input :homeroom
      f.input :status
    end
    f.buttons

    f.inputs "Student Details" do 
      f.has_many :students do |s|
        s.input :account_id, :collection => Account.find(params[:id])
        s.input :first_name
        s.input :other_names
        s.input :teacher
        s.input :comments
      end

    end
    f.buttons
  end

end


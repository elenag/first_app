ActiveAdmin.register Homeroom do

 # menu false

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



# ActiveAdmin.register Account do
# #  menu false
 

#     filter :project, :include_blank => false, :as => :select, :label => "Project", 
#         :collection => proc {Project.all} rescue nil
#     filter :school, :as => :select, :label => "School", 
#         :collection => proc {School.all} rescue nil
#     filter :homeroom, :as => :select, :label => "Classroom", 
#         :collection => proc {Homeroom.all} rescue nil
#     filter :device_type
#     filter :name #, :as => :select, :label => "Account", 
#         #:collection => proc {Account.all.where(:id => :account_id)} rescue nil
#     filter :control
#     filter :flagged
#     filter :serial_number
#     filter :status, :as =>select, :label => "Status", :collection => proc {Device.all} rescue nil
#     filter :reinforced_screen
#     filter :purchase_order
#     filter :number_broken


#   index do
#       selectable_column
#       column("Account") { |account| account.acc_number }
#          column "Surname" do |account| 
#              account.students.map(&:other_names).join("<br />").html_safe
#          end
#          column "Name" do |account| 
#              account.students.map(&:first_name).join("<br />").html_safe
#          end
#          column("Serial No") do |account|
#              account.devices.map(&:serial_number).join("<br />").html_safe
#          end
#          column("DevType") do |account|
#               account.devices.device_types.map(&:name).join("<br />").html_safe
#           end
#          column ("DevStatus") do |account| 
#               account.devices.map(&:status).join("<br />").html_safe 
#          end
#       #   column('Reinforced') { |account| account.device.reinforced_screen }
#          column :comments 
#          column :number_broken 
#     end

#     # csv do
#     #     column("Account") do |device|
#     #       device.account.acc_number
#     #     end
#     #     column "Surname" do |device| 
#     #         device.account.students.map(&:other_names).join(", ")
#     #     end
#     #     column "Name" do |device| 
#     #         device.account.students.map(&:first_name).join(", ")
#     #     end
#     #     column("SerialNumber") {|device| device.serial_number }
#     #     column("Type") { |device| device.device_type.name }
#     #     column("Status") { |device| device.status }
#     #     column('Reinforced') { |device| device.reinforced_screen }
#     #     column("Comments") { |device| device.account.comments }
#     #     column("Broken") { |device| device.account.number_broken }
#     # end

#   form do |f|
#     f.inputs "Account Details" do
#       f.input :acc_number
#       f.input :homeroom
#       f.input :status
#     end
#     f.buttons

#     f.inputs "Student Details" do 
#       f.has_many :students do |s|
#         s.input :account_id, :collection => Account.find(params[:id])
#         s.input :first_name
#         s.input :other_names
#         s.input :teacher
#         s.input :comments
#       end

#     end
#     f.buttons
#   end

# end


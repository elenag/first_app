ActiveAdmin.register Homeroom do
  menu :if => proc{ current_admin_user.ops_rel? or current_admin_user.can_edit_origins? },
       :parent => "Projects", :priority => 2


  index do
    selectable_column
    column "Name" do |hr|
      link_to hr.name, admin_book_path(book)
    end
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
        row "Number of Accounts" do 
          homeroom.accounts.where(:status => 'active').count
        end
        # row "Number of Pupils" do 
        #   homeroom.students.count
        # end
        row "Number of Working Devices" do 
          homeroom.devices.where(:status => 'ok')
        end
      end
    end
    panel("Classroom details") do
      table_for homeroom.accounts.where(:status => 'active') do 
        column "List of Accounts" do |account|
#          account.acc_number
        # column("List of Accounts") do 
        #   link_to homeroom.accounts.map(&:acc_number).join("<br />").html_safe #, admin_account_path(account) 
        end 
        column "Device" do |account|
 #         account.devices.where(:status => 'ok').count #("Number of devices") accounts.devices
        end
      end
    end
  end

  form do |f|
    f.inputs "Homeroom Details" do
      f.input :name
      f.input :school
      f.input :content_buckets
      f.has_many :accounts do |acc|
        acc.input :acc_number
        acc.input :status
        acc.input :number_broken
        acc.input :flagged
        acc.input :comments
      end
    end
  f.buttons

  end


end



 ActiveAdmin.register Account do
  menu :parent => "Students"
 
  action_item :only => :index do
    link_to 'Upload Accounts.csv', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("account", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

    filter :project, :include_blank => false, :as => :select, :label => "Project", 
        :collection => proc {Project.all} rescue nil
    filter :school, :as => :select, :label => "School", 
        :collection => proc {School.all} rescue nil
    filter :homeroom, :as => :select, :label => "Classroom", 
        :collection => proc {Homeroom.all} rescue nil
    filter :device_type
    filter :name #, :as => :select, :label => "Account", 
        #:collection => proc {Account.all.where(:id => :account_id)} rescue nil
    filter :control
    filter :flagged
    filter :serial_number
    filter :status, :as =>select, :label => "Status", :collection => proc {Device.all} rescue nil
    filter :reinforced_screen
    filter :purchase_order
    filter :number_broken


    index do
      selectable_column
         column("Account Number") do |account| 
            link_to account.acc_number, admin_account_path(account)
         end
         column "Surname" do |account| 
             account.students.map(&:other_names).join("<br />").html_safe
         end
         column "Name" do |account| 
             account.students.map(&:first_name).join("<br />").html_safe
         end
         column("Serial No") do |account|
             account.devices.map(&:serial_number).join("<br />").html_safe
         end
         # column("DevType") do |account|
         #      account.devices.device_types.map(&:name).join("<br />").html_safe
         #  end
         # column ("DevStatus") do |account| 
         #      account.devices.map(&:status).join("<br />").html_safe 
         # end
      #   column('Reinforced') { |account| account.device.reinforced_screen }
         column :comments 
         column :number_broken 
    end

    # csv do
    #     column("Account") do |device|
    #       device.account.acc_number
    #     end
    #     column "Surname" do |device| 
    #         device.account.students.map(&:other_names).join(", ")
    #     end
    #     column "Name" do |device| 
    #         device.account.students.map(&:first_name).join(", ")
    #     end
    #     column("SerialNumber") {|device| device.serial_number }
    #     column("Type") { |device| device.device_type.name }
    #     column("Status") { |device| device.status }
    #     column('Reinforced') { |device| device.reinforced_screen }
    #     column("Comments") { |device| device.account.comments }
    #     column("Broken") { |device| device.account.number_broken }
    # end

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

 end


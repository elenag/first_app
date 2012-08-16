class Project < ActiveRecord::Base
  attr_accessible :name, :model_id, :origin_id, :project_type_id, :schools_attributes, :homerooms_attributes, :content_buckets_attributes, :target_size, :current_size

  has_many :schools, :dependent => :destroy
  accepts_nested_attributes_for :schools, :allow_destroy => true
  has_many :homerooms, :through => :schools
  accepts_nested_attributes_for :homerooms, :allow_destroy => true
  has_many :content_buckets
  accepts_nested_attributes_for :content_buckets
  has_and_belongs_to_many :assosiated_books, :class_name => "Book"
  
  has_many :accounts, :through => :homerooms
  accepts_nested_attributes_for :accounts, :allow_destroy => true
  belongs_to :origin, :include => :continent
  accepts_nested_attributes_for :origin, :allow_destroy => true
  belongs_to :model
  belongs_to :project_type
  has_and_belongs_to_many :admin_users, :join_table => :admin_users_projects
  has_many :purchase_orders


  validates :name, :origin_id, :presence => true

  
#  scope :kits, where(:project_type_id => 1)#ProjectType.find_by_name('Kits') )

  class << self
    def status_collection
      {
        "Draft" => STATUS_DRAFT,
        "Sent" => STATUS_SENT,
        "Paid" => STATUS_PAID
      }
    end

    def projects_CB
      @content_buckets = ContentBucket.projects_content_buckets( :id)#.count
      print @content_buckets
    end
    
    def this_month
      where('created_at >= ?', Date.new(Time.now.year, Time.now.month, 1).to_datetime)
    end
  end
  
  def total_classes
    items_total = 0
    self.schools.each do |i|
      items_total += i.homerooms.count
    end
    items_total
  end

  def accounts_active
    account_total = 0
    self.homerooms.each do |h|
        account_total +=h.accounts.where(:status => Account::STATUS_ACTIVE).count
    end
    account_total
  end

  def students_with_devices
    devices_total = 0
    self.schools.each do |s|
      s.homerooms.each do |h|
        h.accounts.each do |a|
          a.students.each do |s|
            if s.role == 'student'
               devices_total += a.devices.where(:status => Device::STATUS_OK).count
            end
          end
        end
      end
    end
    devices_total
  end

  def others_with_devices
    devices_total = 0
    self.schools.each do |s|
      s.homerooms.each do |h|
        h.accounts.each do |a|
          a.students.each do |s|
            if s.role != 'student'
              devices_total += a.devices.where(:status => Device::STATUS_OK).count
            end
          end
        end
      end
    end
    devices_total
  end

  def out_of_order
    devices_total = 0
    self.schools.each do |s|
      s.homerooms.each do |h|
        h.accounts.each do |a|
               devices_total += a.devices.where(:status => Device::STATUS_BROKEN).count
        end
      end
    end
    devices_total
  end



end

#def total_schools
  #    items_total = 0
  #    self.school.each do |school|
    #  	self.school.homeroom.each do |homeroom|
   #   	  self.school.homeroom.account.each do |account|
  #    		items_total +=account.device.where(:status => 'OK')
 #     	  end
 #     	end
 #     end
 #     items_total
 #   end

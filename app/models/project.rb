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
      account_total +=h.accounts.where(:status => 'accounts_with_devices').count
    end
    account_total
  end

  def students_with_devices
    st_devices = Project.count_by_sql("select count(*) from projects p, schools s, homerooms h, accounts a, students st, devices d where d.status = '%s' and d.account_id = a.id and st.account_id = a.id and st.role = '%s' and a.homeroom_id = h.id and h.school_id = s.id and s.project_id = %d" % [ Device::STATUS_OK, 'student', self.id ])
    st_devices = st_devices / 6
  end

  # def students_with_devices
  #   devices_total = 0
  #   self.schools.each do |s|
  #     s.homerooms.each do |h|
  #       h.accounts.each do |a|
  #         a.students.each do |s|
  #           if s.role == 'student'
  #              devices_total += a.devices.where(:status => Device::STATUS_OK).count
  #           end
  #         end
  #       end
  #     end
  #   end
  #   devices_total
  # end

  def accounts_with_devices
    devices_total = 0
    self.schools.each do |s|
      s.homerooms.each do |h|
        h.accounts.each do |a|
          devices_total += a.devices.where(:status => Device::STATUS_OK).count
        end
      end
    end
    devices_total
  end



  def others_with_devices
    count = Project.count_by_sql("select count(*) from projects p, schools s, homerooms h, accounts a, devices d, students st where st.role != '%s' and st.account_id = a.id and d.account_id = a.id and d.status = '%s' and a.homeroom_id = h.id and h.school_id = s.id and s.project_id = %d" % ['student', Device::STATUS_OK, self.id ])
    count = count / 6
  end

  def out_of_order
    count_in = Project.count_by_sql("select count(*) from projects p, schools s, homerooms h, accounts a, devices d where d.status != '%s' and d.account_id = a.id and a.status = '%s' and a.homeroom_id = h.id and h.school_id = s.id and s.project_id = %d" % [Device::STATUS_OK, 'active', self.id ])

  end


end



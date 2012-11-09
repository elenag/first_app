class Homeroom < ActiveRecord::Base
  attr_accessible :homeroom_id, :name, :school_id, :content_bucket_ids, :accounts_attributes, :content_bucket_attributes
  
  belongs_to :school
  has_one :project, :through => :school

  has_many :accounts
  accepts_nested_attributes_for :accounts
  has_many :students, :through => :accounts
  has_many :devices, :through => :accounts

  has_and_belongs_to_many :content_buckets, :join_table => :content_buckets_homerooms
  accepts_nested_attributes_for :content_buckets
  has_many :pushes, :through => :content_bucket
  has_many :books, :through => :pushes

  validates :name, :school_id, :presence => true
  validates_uniqueness_of :name

  class << self
    def students_accounts_in_homeroom
      self.accounts.where(:status => 'active').where(:role =>'student')
    end

    def students_devices_in_homeroom
      self.accounts.with_device?.count
    end

    def students_accounts_in_homeroom
      self.accounts.where(:status => 'active').where(:role =>'student')
    end

    def teachers_accounts_in_homeroom
      self.accounts.where(:status => 'active').where(:role =>'teacher')
    end

    def number_of_other_accounts_in_homeroom
      self.accounts.where(:status => 'active').where(:role => !('teacher' || 'student'))
    end

    def students_with_devices
      devices_total = 0
      self.accounts.each do |a|
        a.students.each do |s|
          if s.role == 'student'
            devices_total += a.devices.where(:status => 'ok').count
          end
        end
      end
      devices_total
    end

    def accounts_without_devices
      devices_total = 0
      acc_total=0
      self.accounts.each do |a|
        devices_total += a.devices.where(:status => Device::STATUS_OK).count
        if a.status == 'active' 
          acc_total += 1
        end
      end
      acc_total-devices_total
    end

  end
end



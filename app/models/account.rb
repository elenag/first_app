class Account < ActiveRecord::Base
  STATUS_ACTIVE = 'active'
  STATUS_CLOSED = 'closed'
  STATUS_SPARE  = 'spare'

  attr_accessible :account_id, :acc_number, :number_broken, :flagged, :comments, :status, :homeroom_id, :content_buckets_id, :device_attributes, :student_attributes, :school_id, :project_id

  belongs_to :homeroom
  has_one :school, :through => :homeroom
  has_one :project, :through => :school

 
  has_one :student
  accepts_nested_attributes_for :student
  has_many :devices
  accepts_nested_attributes_for :devices

  has_and_belongs_to_many :content_buckets

  validates :acc_number, :status, :homeroom_id, :presence => true
  validates_uniqueness_of :acc_number

  class << self

    def show_students
  	  @student = Student.where(:account_id => self.id)
  	  unless @student.empty? 
  		  student.other_names
  	  else
  		  "Friendy child"
  	  end
    end

    def students_count
      Student.find(:id).count
    end

    def with_device
      self.devices.each do |device|
        if device.status.eql?('ok') then
          return true
        end
      end
      return false  
    end

  end

  
end

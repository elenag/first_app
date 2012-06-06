class Account < ActiveRecord::Base
  attr_accessible :account_id, :acc_number, :status, :homeroom_id, :content_buckets_id, :device_attributes, :students_attributes
  
#  acts_as_list :scope => :sclass

  belongs_to :homeroom, :include => :school
#  accepts_nested_attributes_for :homeroom
#  belongs_to :school, :through => :sclass
#  accepts_nested_attributes_for :sclass
#  accepts_nested_attributes_for :school
 
  has_many :students
  accepts_nested_attributes_for :students
  has_many :devices
  accepts_nested_attributes_for :devices

  has_and_belongs_to_many :content_buckets

  validates :acc_number, :presence => true

  def show_student
  	student = Student.where(:account_id => self.id)
  	if student 
#  		"#{student.first_name, student.other_names }"
  	else
  		"Friendy child"
  	end
  end
end

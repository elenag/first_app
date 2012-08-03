class Student < ActiveRecord::Base
  ROLE_STUDENT = 'student'
  ROLE_TEACHER = 'teacher'
  ROLE_PROJECT_MANAGER = 'pr_manager'
  ROLE_STAFF = 'staff'
  ROLE_OTHER = 'other'

  attr_accessible :first_name, :other_names, :account_id, :role, :comments
  
  belongs_to :account #, :include => :homeroom
  has_one :homeroom, :through => :account
  has_one :school, :through => :homeroom
  has_many :content_buckets, :through => :homeroom
  has_many :books, :through => :content_buckets


  validates :first_name, :other_names, :role, :account_id, :presence => true
  validates :role, :inclusion => { :in => [ROLE_STUDENT, ROLE_TEACHER, ROLE_PROJECT_MANAGER, ROLE_STAFF, ROLE_OTHER], :message =>"You need to select a role" }


  class << self
    def students_roles_collection
      {
        "Student" => ROLE_STUDENT,
        "Teacher" => ROLE_TEACHER,
        "Project Manager" => ROLE_PROJECT_MANAGER,
        "Staff" => ROLE_STAFF,
        "Other" => ROLE_OTHER
      }
    end
  end
end

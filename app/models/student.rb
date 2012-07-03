class Student < ActiveRecord::Base
  ROLE_STUDENT = 'student'
  ROLE_TEACHER = 'teacher'
  ROLE_PROJECT_MANAGER = 'pr_manager'
  ROLE_STAFF = 'staff'
  ROLE_OTHER = 'other'

  attr_accessible :first_name, :other_names, :account_id, :teacher, :comments
  
  belongs_to :account


  validates :first_name, :other_names, :role, :account_id, :presence => true
  validates :role, :inclusion => { :in => [ROLE_STUDENT, ROLE_TEACHER, ROLE_PROJECT_MANAGER, ROLE_STAFF, ROLE_OTHER], :message =>"You need to select a role" }
end

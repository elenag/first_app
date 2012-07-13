class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :can_edit_origins, :id, :project_ids
  # attr_accessible :title, :body
  has_and_belongs_to_many :projects, :join_table => :admin_users_projects
  has_many :purchase_orders, :through => :projects
  has_many :devices, :through => :purchase_orders

  def getProjects
  	#projects.all
  end
end

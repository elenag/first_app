class Order < ActiveRecord::Base
   attr_accessible :confirmed, :admin_user_id, :project_id, :created_at, :updated_at

   belongs_to :admin_user
   belongs_to :project

   has_many :order_items
  
end

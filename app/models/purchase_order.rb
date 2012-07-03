class PurchaseOrder < ActiveRecord::Base
   attr_accessible :po_number, :date_ordered, :warranty_end_date, :project_id, :comments

  has_many :devices
  belongs_to :project

  validates :po_number, :warranty_end_date, :dated_ordered, :project_id, :presence => true

end

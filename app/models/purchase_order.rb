class PurchaseOrder < ActiveRecord::Base
   attr_accessible :po_number, :date_ordered, :warranty_end_date, :project_id, :comments

  has_many :devices
  belongs_to :project

  validates :po_number, :warranty_end_date, :date_ordered, :project_id, :presence => true

  def in_warranty
    warranty_end_date > Date.new(Time.now.year, Time.now.month, Time.now.day).to_datetime
  end
end

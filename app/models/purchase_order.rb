class PurchaseOrder < ActiveRecord::Base
   attr_accessible :po_number, :date_ordered, :date_received

  has_many:devices

  validates :po_number, :presence => true
end

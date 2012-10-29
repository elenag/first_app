class Publisher < ActiveRecord::Base
  attr_accessible :name, :origin_id, :address, :telephone, :email, :account_name, :account_number, :bank,
  					:branch, :swift_code, :branch_code, :bank_code, :name_US_corresponding_bank,
  					:routing_number, :contract_end_date, :pub_contacts_attributes, :free
 

  has_many :books
  has_many :pub_contacts
  belongs_to :origin, :include => :continent

  accepts_nested_attributes_for :origin, :books, :pub_contacts

  validates :name, :origin_id, :presence => true
end

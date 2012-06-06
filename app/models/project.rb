class Project < ActiveRecord::Base
  attr_accessible :name, :model_id, :origin_id, :schools_attributes, :homerooms_attributes, :target_size, :current_size

  has_many :schools, :dependent => :destroy
  accepts_nested_attributes_for :schools, :allow_destroy => true
  has_many :homerooms, :through => :schools
  accepts_nested_attributes_for :homerooms, :allow_destroy => true
  belongs_to :origin, :include => :continent
  accepts_nested_attributes_for :origin, :allow_destroy => true
  belongs_to :model

  validates :name, :presence => true

  class << self
    def status_collection
      {
        "Draft" => STATUS_DRAFT,
        "Sent" => STATUS_SENT,
        "Paid" => STATUS_PAID
      }
    end
    
    def this_month
      where('created_at >= ?', Date.new(Time.now.year, Time.now.month, 1).to_datetime)
    end
  end
  
  def total_classes
    items_total = 0
    self.schools.each do |i|
      items_total += i.homerooms.count
    end
    items_total
  end

  def accounts_active
    account_total = 0
    self.homerooms.each do |h|
        account_total +=h.accounts.where(:status => 'OK').count
    end
    account_total
  end

  def devices_active
    devices_total = 0
    self.homerooms.each do |h|
      h.accounts.each do |a|
        devices_total +=a.devices.where(:status => 'OK').count
      end
    end
    devices_total
  end
 
end

#def total_schools
  #    items_total = 0
  #    self.school.each do |school|
    #  	self.school.homeroom.each do |homeroom|
   #   	  self.school.homeroom.account.each do |account|
  #    		items_total +=account.device.where(:status => 'OK')
 #     	  end
 #     	end
 #     end
 #     items_total
 #   end

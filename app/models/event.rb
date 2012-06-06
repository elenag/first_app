class Event < ActiveRecord::Base
  attr_accessible :name

  belongs_to :device

  class << self
    def events_name_collection
      {
      	"Purchased" => STATUS_PURCHASED,
        "Assigned" => STATUS_ASSIGNED,
        "Broken" => STATUS_BROKEN,
        "Missing" => STATUS_MISSING
      }
    end
    
    def this_month
      where('created_at >= ?', Date.new(Time.now.year, Time.now.month, 1).to_datetime)
    end
  end
  
end

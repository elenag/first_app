class Event < ActiveRecord::Base
  attr_accessible :name, :device_id

  belongs_to :device

  class << self
    def events_name_collection
      {
        "Assigned" => 'assigned',
        "Broken" => 'broken',
        "Missing" => 'missing',
        "Returned" => 'returned',
        "Repaired" => 'repaired'
      }
    end
    
    def this_month
      where('created_at >= ?', Date.new(Time.now.year, Time.now.month, 1).to_datetime)
    end

    def createEvent(device_id)
      Event.create

      Project.all
    end

  end
  
end

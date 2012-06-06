class Device < ActiveRecord::Base
  STATUS_OK = 'ok'
  STATUS_BROKEN = 'broken'
  STATUS_MISSING = 'missing'
  STATUS_SPARE = 'spare'
  
  attr_accessible :serial_number, :status, :flagged, :control, :reinforced_screen, :device_type, :account_id, :device_type_id, :purchase_order_id, :events_attributes
  
  belongs_to :account
  belongs_to :purchase_order
  belongs_to :device_type

  has_many  :events
  accepts_nested_attributes_for :events, :allow_destroy => true


  has_one :homeroom, :through => :account
  has_one :school, :through => :homeroom
  has_one :project, :through => :school
  validates :serial_number, :presence => true
  validates :status, :inclusion => { :in => [STATUS_OK, STATUS_BROKEN, STATUS_MISSING], :message => "You need to pick one status." }

class << self
    def status_collection
      {
        "OK" => STATUS_OK,
        "Broken" => STATUS_BROKEN,
        "Missing" => STATUS_MISSING,
        "Spare" => STATUS_SPARE
      }
    end
    
    def this_month
      where('created_at >= ?', Date.new(Time.now.year, Time.now.month, 1).to_datetime)
    end
  end

  def last_event
    Event.where(:device_id => self.id).last
  end

  def project_search
    @project = Project.all.where(:name => :in_name)
    @school = School.all.where(:project_id => @project.id)
  end

#    @projects_with_awesome_users_search =
#  Project.joins(:user).where(:users => {:awesome => true}).search(params[:search])

end

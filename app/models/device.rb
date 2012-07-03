class Device < ActiveRecord::Base
  STATUS_OK = 'ok'
  STATUS_BROKEN = 'broken'
  STATUS_MISSING = 'missing'
  STATUS_SPARE = 'spare'
  STATUS_RETURNED =  'returned' 
  STATUS_REPAIRED = 'repaired'
  STATUS_DISPOSED = 'disposed'
  STATUS_TO_RETURN = 'to_return'
  STATUS_TO_REPAIR = 'to_repair'

  BROKEN_SCREEN = 'broken_screen'
  FROZEN_SCREEN = 'frozen_screen'
  CONNECTIVITY_PROBLEM = 'connectivity_problem'
  LOOSE_CHARGE_CONTACT = 'loose_contact'

  
  attr_accessible :serial_number, :status, :flagged, :control, :reinforced_screen, :device_type, :account_id, :device_type_id, :purchase_order_id, :events_attributes
  
  belongs_to :account
  belongs_to :purchase_order
  belongs_to :device_type

  has_many  :events
  accepts_nested_attributes_for :events, :allow_destroy => true


  has_one :homeroom, :through => :account
  has_one :school, :through => :homeroom
  has_one :project, :through => :purchase_order
  validates :serial_number, :device_type_id, :purchase_order_id, :status, :presence => true
  validates :status, :inclusion => { :in => [STATUS_OK, STATUS_BROKEN, STATUS_MISSING, STATUS_SPARE, STATUS_RETURNED, STATUS_REPAIRED, STATUS_DISPOSED, STATUS_TO_RETURN,STATUS_TO_REPAIR], :message => "You need to pick one status." }
  validates :return_reason, :inclusion => { :in => [BROKEN_SCREEN, FROZEN_SCREEN, CONNECTIVITY_PROBLEM, LOOSE_CHARGE_CONTACT], :message => "You need to pick a reason for return." }

class << self
    def device_status_collection
      {
        "OK" => STATUS_OK,
        "Broken" => STATUS_BROKEN,
        "Missing" => STATUS_MISSING,
        "Spare" => STATUS_SPARE,
        "Returned" => STATUS_RETURNED,
        "Repaired" => STATUS_REPAIRED,
        "Disposed" => STATUS_DISPOSED
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

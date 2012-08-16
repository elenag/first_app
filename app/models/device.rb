class Device < ActiveRecord::Base
  scope :OK, where(:status => 'ok' )
  scope :BROKEN, where(:status => 'broken' )
  scope :SPARE, where(:status => 'spare')
  scope :TO_REPAIR, where(:action => 'repair')
  scope :TO_RETURN, where(:action => 'return')

  STATUS_OK = 'ok'
  STATUS_BROKEN = 'broken'
  STATUS_SPARE = 'spare'
  STATUS_DECEASED = 'deceased'

#Reasons For Return:

  BROKEN_SCREEN = 'broken_screen'
  FROZEN_SCREEN = 'frozen_screen'
  CONNECTIVITY_PROBLEM = 'connectivity_problem'
  LOOSE_CHARGE_CONTACT = 'loose_contact'
  
  attr_accessible :serial_number, :return_reason,
                  :status, :action, :flagged, :control, 
                  :reinforced_screen, :device_type, :account_id, 
                  :device_type_id, :purchase_order_id, :events_attributes
  
  belongs_to :account
  accepts_nested_attributes_for :account
  belongs_to :purchase_order
  belongs_to :device_type

  has_many  :events
  accepts_nested_attributes_for :events, :allow_destroy => true


  has_one :homeroom, :through => :account
  has_one :school, :through => :homeroom
  has_one :project, :through => :purchase_order
  has_many :admin_users, :through => :project
  validates :serial_number, :device_type_id, :purchase_order_id, :status, :presence => true
  validates :status, :inclusion => { :in => [STATUS_OK, STATUS_BROKEN, STATUS_SPARE, STATUS_DECEASED], :message => "You need to pick one status." }
#  validates :return_reason, :inclusion => { :in => [BROKEN_SCREEN, FROZEN_SCREEN, CONNECTIVITY_PROBLEM, LOOSE_CHARGE_CONTACT], :message => "You need to pick a reason for return." }



class << self
    def device_status_collection
      {
        "OK" => STATUS_OK,
        "Broken" => STATUS_BROKEN,
        "Spare" => STATUS_SPARE,
        "Deceased" => STATUS_DECEASED
      }
    end

    def device_action_collection
      {
        "None" => 'none',
        "To Repair" => 'repair',
        "To return" => 'return'
      }
    end

    def projectSelector
      Project.all
    end

    def getDevicePromProject
     # AdminUser.getProjects
      #userProjects = Project.where(:id => [AdminUser.getProjects.id]);
      #print userProjects
      #Device.where(:purchase_order_id => Project::STATUS_OK).count)
    end
    
    def this_month
      where('created_at >= ?', Date.new(Time.now.year, Time.now.month, 1).to_datetime)
    end
  end

  def last_event
    Event.where(:device_id => self.id).last
  end

  def new_event(pname)
    if pname.eql?('assigned') || pname.eql?('repaired') then 
      self.update_attribute(:status, 'ok')
      self.update_attribute(:action, 'none')
    elsif pname.eql?('broken') then
      if purchase_order.warranty_end_date > Date.new(Time.now.year, Time.now.month, Time.now.day).to_datetime then
        self.update_attribute(:action, 'return')
      else
        self.update_attribute(:action, 'repair')
      end
      self.update_attribute(:status, 'broken')
      @numbroken = Account.find(self.account_id).number_broken rescue nil
      if @numbroken.nil?
        @numbroken = 1
      else
        @numbroken += 1
      end

      self.account.update_attribute(:number_broken, @numbroken)
 #     @nb = account.find_by_device_id(self.id).number_broken + 1
 #     account.update_attribute(:number_broken, @nb)
    elsif pname.eql?('returned') || pname.eql?('missing') #|| pname.eql?('disposed')  
      self.update_attribute(:action, 'none')
      self.update_attribute(:status, STATUS_DECEASED)
      self.update_attribute(:account_id, 0)
    else
      self.update_attribute(:action, 'none')
      self.update_attribute(:status, STATUS_DECEASED)
      self.update_attribute(:account_id, 0)
    end
    Event.new(:device_id => self.id, :name => pname).save
  end



  def project_search
    @project = Project.where(:name => :in_name)
    @schools = School.where(:project_id => @project.id)
  end

#    @projects_with_awesome_users_search =
#  Project.joins(:user).where(:users => {:awesome => true}).search(params[:search])

end

class School < ActiveRecord::Base
  attr_accessible :name, :project_id, :homerooms_attributes
#  serialize :sclasses, SclassesList


  belongs_to :project
#  accepts_nested_attributes_for :project
  
  has_many :homerooms, :dependent => :destroy
  accepts_nested_attributes_for :homerooms, :allow_destroy => true

  has_many :students

  has_many :accounts, :through => :homerooms
  accepts_nested_attributes_for :accounts

  validates :name, :project_id, :presence => true

end

#class SclassesList < Array
#  def self.dump(homerooms)
#    homerooms ? homerooms.join("\n") : nil
#  end
 
#  def self.load(homerooms)
#    homerooms ? new(homerooms.split("\n")) : nil
#  end
#end


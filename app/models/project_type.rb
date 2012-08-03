class ProjectType < ActiveRecord::Base
  attr_accessible :name, :id

  has_many :projects

  class << self
    def search_kits
       @pt_id = ProjectType.search(params[:name, 'Kits'])
    end
  end
end

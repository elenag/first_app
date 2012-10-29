class AddRightsToPublishers < ActiveRecord::Migration
  def change
  	add_column :publishers, :free, :boolean
  end
end

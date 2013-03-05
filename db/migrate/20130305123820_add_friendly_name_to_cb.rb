class AddFriendlyNameToCb < ActiveRecord::Migration
  def change
  	add_column :content_buckets, :friendly_name, :string
  end
end

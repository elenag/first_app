class AddProjectToContentBucket < ActiveRecord::Migration
  def change
  	add_column("content_buckets", "project_id", "integer")
  end
end

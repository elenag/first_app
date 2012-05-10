class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
    	t.string 'first_name'
    	t.string 'other_names'
    	

      t.timestamps
    end
  end
end

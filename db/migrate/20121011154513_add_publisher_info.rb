class AddPublisherInfo < ActiveRecord::Migration
  
  def change
  	add_column :publishers, :address, :string
  	add_column :publishers, :telephone, :string
  	add_column :publishers, :email, :string
  	add_column :publishers, :account_name, :string
  	add_column :publishers, :account_number, :string
  	add_column :publishers, :bank, :string
  	add_column :publishers, :branch, :string
    add_column :publishers, :swift_code, :string
  	add_column :publishers, :branch_code, :string
  	add_column :publishers, :bank_code, :string
  	add_column :publishers, :name_US_corresponding_bank, :string
  	add_column :publishers, :routing_number, :string
  	add_column :publishers, :contract_end_date, :date
  end

end

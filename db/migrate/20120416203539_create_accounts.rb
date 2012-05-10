class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
        t.string "acc_number"
        t.references :sclass
        t.references :school
        t.timestamps
    end
  end
end

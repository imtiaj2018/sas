class CreateBillDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_details do |t|

      t.timestamps
    end
  end
end

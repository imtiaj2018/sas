class CreateClientWorkDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :client_work_details do |t|

      t.timestamps
    end
  end
end

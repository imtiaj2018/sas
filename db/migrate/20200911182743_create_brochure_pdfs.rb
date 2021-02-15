class CreateBrochurePdfs < ActiveRecord::Migration[5.2]
  def change
    create_table :brochure_pdfs do |t|

      t.timestamps
    end
  end
end

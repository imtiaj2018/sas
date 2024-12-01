class CreateQrcodePdfs < ActiveRecord::Migration[5.2]
  def change
    create_table :qrcode_pdfs do |t|

      t.timestamps
    end
  end
end

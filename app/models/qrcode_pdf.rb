class QrcodePdf < ApplicationRecord
    def self.save_pdf_file_for_qr(file_name,display_name,file_extention)
		# ActiveRecord::Base.connection.execute("DELETE from  documentations where document_type = '#{file_extention}';")
		doc_obj=QrcodePdf.new
		doc_obj.file_name = file_name
		doc_obj.display_name = display_name
		doc_obj.document_type = file_extention
		doc_obj.save
	end

	def self.get_qr_code_grid_data_details(limit=nil)
		if limit != nil
			uplimit= limit.split('_')[1]
			lowlimit= limit.split('_')[0]
			return QrcodePdf.find_by_sql("SELECT * FROM qrcode_pdfs limit #{lowlimit},#{uplimit}")
		end
		return QrcodePdf.find_by_sql("SELECT count(*) as cc FROM qrcode_pdfs;")
	end

	def self.delete_qrcode_file(id)
		ActiveRecord::Base.connection.execute("delete from qrcode_pdfs where id = #{id};")
	end

end

class BrochurePdf < ApplicationRecord
	def self.save_documentation_file(file_name,display_name,file_extention)
		# ActiveRecord::Base.connection.execute("DELETE from  documentations where document_type = '#{file_extention}';")
		doc_obj=BrochurePdf.new
		doc_obj.file_name = file_name
		doc_obj.display_name = display_name
		doc_obj.document_type = file_extention
		doc_obj.save
	end
	
	def self.download_document_file
		filename = BrochurePdf.where("document_type= '.pdf'").last.file_name rescue ""
		return filename
	end
	
	def self.get_documentation_grid_data_details(limit=nil)
		if limit != nil
			uplimit= limit.split('_')[1]
			lowlimit= limit.split('_')[0]
			return BrochurePdf.find_by_sql("SELECT * FROM brochure_pdfs limit #{lowlimit},#{uplimit}")
		end
		return BrochurePdf.find_by_sql("SELECT count(*) as cc FROM brochure_pdfs;")
	end
	
	def self.delete_document_file(id)
		ActiveRecord::Base.connection.execute("delete from brochure_pdfs where id = #{id};")
	end
end

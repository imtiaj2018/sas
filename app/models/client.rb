class Client < ApplicationRecord
	def self.get_project_logo_grid_data_details(limit=nil)
		if limit != nil
			uplimit= limit.split('_')[1]
			lowlimit= limit.split('_')[0]
			return Client.find_by_sql("SELECT * FROM clients limit #{lowlimit},#{uplimit}")
		end
		return Client.find_by_sql("SELECT count(*) as cc FROM clients;")
	end
	
	def self.save_client_logo_file(file_name,display_name,client_name)
		doc_obj=Client.new
		doc_obj.file_name = file_name
		doc_obj.display_name = display_name
		doc_obj.client_name = client_name
		doc_obj.save
	end
	
	def self.delete_client_logo_image_file(id)
		ActiveRecord::Base.connection.execute("delete from clients where id = #{id};")
	end
	
	def self.get_client_images
		return Client.find_by_sql("select * from clients order by display_name").collect{|x| x.file_name}
	end
end

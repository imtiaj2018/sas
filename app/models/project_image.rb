class ProjectImage < ApplicationRecord
	def self.save_project_image_file(file_name,display_name,image_size,final_file_name)
		img_obj=ProjectImage.new
		img_obj.file_name = file_name
		img_obj.display_name = display_name
		img_obj.image_size = image_size
		img_obj.image_path = final_file_name
		img_obj.save
	end
	
	def self.get_project_image_grid_data_details(limit=nil)
		if limit != nil
			uplimit= limit.split('_')[1]
			lowlimit= limit.split('_')[0]
			return ProjectImage.find_by_sql("SELECT * FROM project_images limit #{lowlimit},#{uplimit}")
		end
		return ProjectImage.find_by_sql("SELECT count(*) as cc FROM project_images;")
	end
	
	def self.delete_project_image_file(id)
		ActiveRecord::Base.connection.execute("delete from project_images where id = #{id};")
	end
	
	def self.get_project_images
		# project_images_obj= ProjectImage.all
		project_images_obj= ProjectImage.find_by_sql("select * from project_images order by display_name")
		_hash={}
		project_images_obj.each do|poi|
			_hash[poi["image_size"]] ||=[]
			# _hash[poi["image_size"]] <<poi["file_name"]
			_hash[poi["image_size"]] <<poi["image_path"]
		end
		return _hash
	end
end

class ImagePdfController < ApplicationController
	protect_from_forgery with: :exception, :except => [:upload_documentation_file,:get_documentation_aggrid_data,:delete_document_file, :upload_project_images_form, :get_project_images_aggrid_data, :delete_project_image_file]
	def upload_brochure
		if current_user
			@coldef = create_documentation_grid_coldef
		else
			redirect_to login_url
		end		
	end
	
	def upload_documentation_file
		time = Time.now().strftime("%m_%d_%Y_%I_%M_%S%p")  
		directory="#{Rails.root}/public"  
		if !(File.directory? directory) 	#if directory is not present then creating
			FileUtils.mkdir_p directory, :mode => 0777	rescue nil
		end
		puts params[:upload].inspect
		name =  params[:upload]['datafile'].original_filename   
		file_extention = File.extname(name)
		file_name = name.split(file_extention)[0]
		new_file_name = "#{file_name}_#{time}#{file_extention}"
		final_file_name="#{directory}/#{new_file_name}" 
		
		FileUtils.move params[:upload]['datafile'].path, final_file_name  
		BrochurePdf.save_documentation_file(new_file_name,name,file_extention) 
		session[:document_upload_status]="Uploaded Successfully"
		redirect_to '/upload_brochure'		
	end
	
	def download_documentation  
		puts "ashdgfdgdasgd"
		file_name=BrochurePdf.download_document_file
		directory="#{Rails.root}/public"  
		final_file_name=""
		final_file_name = "#{directory}/#{file_name}" if file_name.strip != "" 
		render :plain => final_file_name		
	end  
	
	def download_file 
		file_name = params[:file_name] if params[:file_name].present? 
		send_file file_name, :type=>"application/csv", :disposition => "attachment", :stream => false 
	end	
	
	def create_documentation_grid_coldef
		grid_header_config_arr=[] 
		grid_header_config_arr <<  {"field" => "id","headerName"=>"ID","width" => 0,"hide" => true}
		grid_header_config_arr << {"field" => "file_name","headerName"=>"File Path","width" => 150,"hide" => true}
		grid_header_config_arr << {"field" => "display_name","headerName"=>"File Name","width" => 500}
		grid_header_config_arr << {"field" => "download_button","headerName"=>"","width" => 100,"cellRenderer" => "simpleRenderer","suppressFilter"=>true,"suppressSorting" => true}
		grid_header_config_arr << {"field" => "delete_button","headerName"=>"","width" => 100,"cellRenderer" => "simpleRenderer","suppressFilter"=>true,"suppressSorting" => true} 
		
		return grid_header_config_arr
	end 
	
	def get_documentation_aggrid_data		
		@column_data = []
		@column_names_field=['id','file_name','display_name','download_button','delete_button']
		customfileds = ['download_button','delete_button']
		agdata = BrochurePdf.get_documentation_grid_data_details(params[:limit])
		agdata_count = BrochurePdf.get_documentation_grid_data_details()
		agdata.each do |data|
			_tempdatahash = {}
			@column_names_field.each do |fieldname|		
				if customfileds.include?(fieldname)
					if fieldname == 'download_button'
						_tempdatahash[fieldname]="<center><input type='button' id='download_file_'#{data.id}' value='Download' onclick=download_file('#{data.id}'); class='corner_border_div_100_green_ag'></center>"	
					elsif fieldname == 'delete_button'
						_tempdatahash[fieldname]="<center><input type='button' id='delete_file_'#{data.id}' class='corner_border_div_100_red_ag' value='Delete' onclick=delete_file('#{data.id}');></center>"	
					end
				else
					_tempdatahash[fieldname] = data[fieldname]
				end 
			end	 
			@column_data << _tempdatahash 
		end
		ag_data={}
		ag_data["total"]=agdata_count[0]["cc"]
		ag_data["data"]=@column_data
		render :plain =>JSON.dump(ag_data)
	end
	
	
	def download_documentation_admin
		id=params[:id]
		file_name=ProjectImage.find(id.to_i).file_name  
		directory="public/project_images"  
		final_file_name = "#{directory}/#{file_name}" 
		send_file final_file_name, :type=>"application/csv", :disposition => "attachment", :stream => false
	end
	
	def delete_document_file
		id = params[:id]
		file_name = BrochurePdf.find(id.to_i).file_name  
		directory="#{Rails.root}/public"  
		final_file_name = "#{directory}/#{file_name}" 
		if File.exist?(final_file_name)
			FileUtils.rm final_file_name, :force => true
		end 
		BrochurePdf.delete_document_file(id)
		render :plain => "This document deleted successfully."
	end 
	
	def upload_project_images
		if current_user
			@coldef = create_image_upload_grid_coldef
		else
			redirect_to login_url
		end
		
	end
	
	def upload_project_images_form
		time = Time.now().strftime("%m_%d_%Y_%I_%M_%S%p")
		directory="#{Rails.root}/project_images"
		if !(File.directory? directory) 	#if directory is not present then creating
			FileUtils.mkdir_p directory, :mode => 0777	rescue nil
		end
		Rails.logger.info "=====directory====#{directory}"
		Rails.logger.info "=====Rails.root====#{Rails.root}"
		name =  params[:upload]['datafile'].original_filename   
		image_size =  params[:image_type]
		file_extention = File.extname(name)
		file_name = name.split(file_extention)[0]
		new_file_name = "#{file_name}_#{time}#{file_extention}"
		final_file_name="#{directory}/#{new_file_name}" 
		
		FileUtils.move params[:upload]['datafile'].path, final_file_name  
		ProjectImage.save_project_image_file(new_file_name,name,image_size,final_file_name) 
		session[:document_upload_status]="Uploaded Successfully"
		redirect_to '/upload_project_images'		
	end
	
	def create_image_upload_grid_coldef
		grid_header_config_arr=[] 
		grid_header_config_arr <<  {"field" => "id","headerName"=>"ID","width" => 0,"hide" => true}
		grid_header_config_arr << {"field" => "file_name","headerName"=>"File Path","width" => 150,"hide" => true}
		grid_header_config_arr << {"field" => "display_name","headerName"=>"File Name","width" => 500}
		grid_header_config_arr << {"field" => "image_size","headerName"=>"Image Size","width" => 100}
		grid_header_config_arr << {"field" => "download_button","headerName"=>"","width" => 100,"cellRenderer" => "simpleRenderer","suppressFilter"=>true,"suppressSorting" => true}
		grid_header_config_arr << {"field" => "delete_button","headerName"=>"","width" => 100,"cellRenderer" => "simpleRenderer","suppressFilter"=>true,"suppressSorting" => true} 
		
		return grid_header_config_arr
	end	
	
	def get_project_images_aggrid_data		
		@column_data = []
		@column_names_field=['id','file_name','display_name','image_size','download_button','delete_button']
		customfileds = ['download_button','delete_button','image_size']
		agdata = ProjectImage.get_project_image_grid_data_details(params[:limit])
		agdata_count = ProjectImage.get_project_image_grid_data_details()
		agdata.each do |data|
			_tempdatahash = {}
			@column_names_field.each do |fieldname|		
				if customfileds.include?(fieldname)
					if fieldname == 'download_button'
						_tempdatahash[fieldname]="<center><input type='button' id='download_file_'#{data.id}' value='Download' onclick=download_file('#{data.id}'); class='corner_border_div_100_green_ag'></center>"	
					elsif fieldname == 'delete_button'
						_tempdatahash[fieldname]="<center><input type='button' id='delete_file_'#{data.id}' class='corner_border_div_100_red_ag' value='Delete' onclick=delete_file('#{data.id}');></center>"	
					elsif fieldname == 'image_size'
						if data.image_size.downcase =='l'
							_tempdatahash[fieldname]="Large"
						else
							_tempdatahash[fieldname]="Small"
						end
					end
				else
					_tempdatahash[fieldname] = data[fieldname]
				end 
			end	 
			@column_data << _tempdatahash 
		end
		ag_data={}
		ag_data["total"]=agdata_count[0]["cc"]
		ag_data["data"]=@column_data
		render :plain =>JSON.dump(ag_data)
	end
	
	def delete_project_image_file
		id = params[:id]
		file_name = ProjectImage.find(id.to_i).file_name  
		directory="#{Rails.root}/public/project_images"  
		final_file_name = "#{directory}/#{file_name}" 
		if File.exist?(final_file_name)
			FileUtils.rm final_file_name, :force => true
		end 
		ProjectImage.delete_project_image_file(id)
		render :plain => "This Project Image deleted successfully."
	end
	
	
end

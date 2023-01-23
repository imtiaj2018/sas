class ClientsController < ApplicationController
	protect_from_forgery with: :exception, :except => [:get_clients_logo_aggrid_data, :upload_client_images_form, :delete_client_logo_image_file]
	def upload_clients
		# if current_user
			@coldef = create_client_grid_coldef
		# else
			# redirect_to login_url
		# end		
	end
	
	def upload_client_images_form
		time = Time.now().strftime("%m_%d_%Y_%I_%M_%S%p")  
		directory="#{Rails.root}/public/client_images"  
		if !(File.directory? directory) 	#if directory is not present then creating
			FileUtils.mkdir_p directory, :mode => 0777	rescue nil
		end
		name =  params[:upload]['datafile'].original_filename   
		client_name =  params[:client_name]  
		file_extention = File.extname(name)
		file_name = name.split(file_extention)[0]
		new_file_name = "#{file_name}_#{time}#{file_extention}"
		final_file_name="#{directory}/#{new_file_name}" 
		
		FileUtils.move params[:upload]['datafile'].path, final_file_name  
		FileUtils.chmod 0777, Dir.glob("#{Rails.root}/public/client_images/*")
		Client.save_client_logo_file(new_file_name,name,client_name) 
		session[:document_upload_status]="Uploaded Successfully"
		redirect_to '/upload_clients'		
	end
	
	def create_client_grid_coldef
		grid_header_config_arr=[] 
		grid_header_config_arr <<  {"field" => "id","headerName"=>"ID","width" => 0,"hide" => true}
		grid_header_config_arr << {"field" => "file_name","headerName"=>"File Path","width" => 150,"hide" => true}
		grid_header_config_arr << {"field" => "display_name","headerName"=>"File Name","width" => 350}
		grid_header_config_arr << {"field" => "client_name","headerName"=>"Client Name","width" => 350}
		grid_header_config_arr << {"field" => "download_button","headerName"=>"","width" => 100,"cellRenderer" => "simpleRenderer","suppressFilter"=>true,"suppressSorting" => true}
		grid_header_config_arr << {"field" => "delete_button","headerName"=>"","width" => 100,"cellRenderer" => "simpleRenderer","suppressFilter"=>true,"suppressSorting" => true} 
		
		return grid_header_config_arr
	end 
	
	def get_clients_logo_aggrid_data		
		@column_data = []
		@column_names_field=['id','file_name','display_name','client_name','download_button','delete_button']
		customfileds = ['download_button','delete_button']
		agdata = Client.get_project_logo_grid_data_details(params[:limit])
		agdata_count = Client.get_project_logo_grid_data_details()
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
	
	
	def download_client_logos
		id=params[:id]
		file_name=Client.find(id.to_i).file_name  
		directory="#{Rails.root}/public/client_images"  
		final_file_name = "#{directory}/#{file_name}" 
		send_file final_file_name, :type=>"application/csv", :disposition => "attachment", :stream => false
	end
	
	def delete_client_logo_image_file
		id = params[:id]
		file_name = Client.find(id.to_i).file_name  
		directory="#{Rails.root}/public/client_images"  
		final_file_name = "#{directory}/#{file_name}" 
		if File.exist?(final_file_name)
			FileUtils.rm final_file_name, :force => true
		end 
		Client.delete_client_logo_image_file(id)
		render :plain => "This client logo deleted successfully."
	end 
	
	
end

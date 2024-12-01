require 'rqrcode'
require 'mini_magick'
class ImagePdfController < ApplicationController
	protect_from_forgery with: :exception, :except => [:delete_qrcode_file, :get_qr_generate_aggrid_data, :upload_pdf_file_for_qr, :upload_documentation_file,:get_documentation_aggrid_data,:delete_document_file, :upload_project_images_form, :get_project_images_aggrid_data, :delete_project_image_file]
	def upload_brochure
		if current_user
			@coldef = create_documentation_grid_coldef
		else
			redirect_to login_url
		end		
	end
	
	def upload_pdf_file_for_qr_generate
		if current_user
			@coldef = create_qr_code_generate_from_pdf_grid_coldef
		else
			redirect_to login_url
		end		
	end

	def upload_pdf_file_for_qr_bk #qr code
		time = Time.now().strftime("%m_%d_%Y_%I_%M_%S%p")  
		# directory="/mnt/misc_files"  
		# if !(File.directory? directory) 	#if directory is not present then creating
		# 	FileUtils.mkdir_p directory, :mode => 0777	rescue nil
		# end
		# puts params[:upload].inspect
		name =  params[:upload]['datafile'].original_filename   
		file_extention = File.extname(name)
		file_name = name.split(file_extention)[0]
		new_file_name = "#{file_name}_#{time}#{file_extention}"
		#final_file_name="#{directory}/#{new_file_name}" 

		final_file_name = Rails.root.join('public', "#{new_file_name}")
		File.chmod(0777, final_file_name)

		
		FileUtils.move params[:upload]['datafile'].path, final_file_name  
		# Set permissions on the file
		File.chmod(0777, final_file_name)
		QrcodePdf.save_pdf_file_for_qr(new_file_name,name,file_extention) 
		session[:document_upload_status]="Uploaded Successfully"
		redirect_to '/upload_pdf_file_for_qr_generate'		
	end


	def upload_pdf_file_for_qr
		# Generate a timestamp for the new file name
		time = Time.now.strftime("%m_%d_%Y_%I_%M_%S%p")
	  
		# Ensure the `params[:upload]` and `params[:upload]['datafile']` are present
		if params[:upload].nil? || params[:upload]['datafile'].nil?
		  session[:document_upload_status] = "File upload failed. No valid file provided."
		  redirect_to '/upload_pdf_file_for_qr_generate' and return
		end
	  
		# Extract the uploaded file's details
		uploaded_file = params[:upload]['datafile']
		name = uploaded_file.original_filename
		file_extension = File.extname(name)
		file_name = name.chomp(file_extension)
	  
		# Generate the new file name
		new_file_name = "#{file_name}_#{time}#{file_extension}"
	  
		# Define the final file path in the public directory
		final_file_path = Rails.root.join('public', new_file_name)
	  
		begin
		  # Move the uploaded file to the final destination
		  FileUtils.move(uploaded_file.path, final_file_path)
	  
		  # Set permissions on the moved file
		  File.chmod(0o777, final_file_path)
	  
		  # Save details to the database or perform any other required operation
		  QrcodePdf.save_pdf_file_for_qr(new_file_name, name, file_extension)
	  
		  # Set success status and redirect
		  session[:document_upload_status] = "Uploaded Successfully"
		rescue StandardError => e
		  # Handle any errors during file operations
		  session[:document_upload_status] = "File upload failed: #{e.message}"
		end
	  
		# Redirect to the next step or show the status
		redirect_to '/upload_pdf_file_for_qr_generate'
	  end
	  

	def upload_documentation_file #brochure
		time = Time.now().strftime("%m_%d_%Y_%I_%M_%S%p")  
		directory="/mnt/misc_files"  
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
		# Set permissions on the file
		File.chmod(0777, final_file_name)
		BrochurePdf.save_documentation_file(new_file_name,name,file_extention) 
		session[:document_upload_status]="Uploaded Successfully"
		redirect_to '/upload_brochure'		
	end
	
	def download_documentation  #brochure
		file_name=BrochurePdf.download_document_file
		directory="/mnt/misc_files"
		final_file_name=""
		final_file_name = "#{directory}/#{file_name}" if file_name.strip != "" 
		render :plain => final_file_name		
	end  
	
	def download_brochure #calling from grid Download button
		id=params[:id]
		file_name=BrochurePdf.find(id.to_i).file_name  
		directory="/mnt/misc_files"  
		final_file_name = "#{directory}/#{file_name}" 
		send_file final_file_name, :type=>"application/csv", :disposition => "attachment", :stream => false
	end

	def download_qr_code #calling from grid Download button
		require 'uri'
		id=params[:id]
		file_name=QrcodePdf.find(id.to_i).file_name  
		output_image_path = Rails.root.join('public', 'qrcode.png')
		# base_url = "http://127.0.0.1:3000"
		base_url = "http://www.sunshineadsolutions.com"
		
		encoded_file_name = URI.encode_www_form_component(file_name)
		url = "#{base_url}/#{encoded_file_name}"
		qr_code = RQRCode::QRCode.new(url)
		# Generate the QR code as an image
		png = qr_code.as_png(size: 300, border_modules: 4)
		# Save the PNG data as an image file
		image = MiniMagick::Image.read(png.to_s) do |img|
			img.format "png"
		end
		image.write(output_image_path)
		send_file output_image_path, type: 'image/png', disposition: 'inline'
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

	def create_qr_code_generate_from_pdf_grid_coldef
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


	def get_qr_generate_aggrid_data		
		@column_data = []
		@column_names_field=['id','file_name','display_name','download_button','delete_button']
		customfileds = ['download_button','delete_button']
		agdata = QrcodePdf.get_qr_code_grid_data_details(params[:limit])
		agdata_count = QrcodePdf.get_qr_code_grid_data_details()
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
		directory="/mnt/project_images"  
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

	def delete_qrcode_file
		id = params[:id]
		file_name = QrcodePdf.find(id.to_i).file_name  
		directory="#{Rails.root}/public"  
		final_file_name = "#{directory}/#{file_name}" 
		if File.exist?(final_file_name)
			FileUtils.rm final_file_name, :force => true
		end 
		QrcodePdf.delete_qrcode_file(id)
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
		directory="/mnt/project_images"
		if !(File.directory? directory) 	#if directory is not present then creating
			FileUtils.mkdir_p directory, :mode => 0777	rescue nil
		end
		Rails.logger.info "=====directory====#{directory}"
		Rails.logger.info "=====Rails.root====#{Rails.root}"
		name =  params[:upload]['datafile'].original_filename   
		# image_size =  params[:image_type]
		file_extention = File.extname(name)
		file_name = name.split(file_extention)[0]
		new_file_name = "#{file_name}_#{time}#{file_extention}"
		final_file_name="#{directory}/#{new_file_name}" 
		
		puts "final_file_name===>>#{final_file_name}"
		
		FileUtils.move params[:upload]['datafile'].path, final_file_name  
		File.chmod(0777, final_file_name)
		# ProjectImage.save_project_image_file(new_file_name,name,image_size) 
		# ProjectImage.save_project_image_file(new_file_name,name,image_size,final_file_name) 
		ProjectImage.save_project_image_file(new_file_name,name,final_file_name) 
		session[:document_upload_status]="Uploaded Successfully"
		redirect_to '/upload_project_images'		
	end
	
	def create_image_upload_grid_coldef
		grid_header_config_arr=[] 
		grid_header_config_arr <<  {"field" => "id","headerName"=>"ID","width" => 0,"hide" => true}
		grid_header_config_arr << {"field" => "file_name","headerName"=>"File Path","width" => 150,"hide" => true}
		grid_header_config_arr << {"field" => "display_name","headerName"=>"File Name","width" => 500}
		# grid_header_config_arr << {"field" => "image_size","headerName"=>"Image Size","width" => 100}
		grid_header_config_arr << {"field" => "download_button","headerName"=>"","width" => 100,"cellRenderer" => "simpleRenderer","suppressFilter"=>true,"suppressSorting" => true}
		grid_header_config_arr << {"field" => "delete_button","headerName"=>"","width" => 100,"cellRenderer" => "simpleRenderer","suppressFilter"=>true,"suppressSorting" => true} 
		
		return grid_header_config_arr
	end	
	
	def get_project_images_aggrid_data		
		@column_data = []
		# @column_names_field=['id','file_name','display_name','image_size','download_button','delete_button']
		@column_names_field=['id','file_name','display_name','download_button','delete_button']
		# customfileds = ['download_button','delete_button','image_size']
		customfileds = ['download_button','delete_button']
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
					# elsif fieldname == 'image_size'
						# if data.image_size.downcase =='l'
							# _tempdatahash[fieldname]="Large"
						# else
							# _tempdatahash[fieldname]="Small"
						# end
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
		# directory="#{Rails.root}/public/project_images"  
		directory="/mnt/project_images"  
		final_file_name = "#{directory}/#{file_name}" 
		if File.exist?(final_file_name)
			FileUtils.rm final_file_name, :force => true
		end 
		ProjectImage.delete_project_image_file(id)
		render :plain => "This Project Image deleted successfully."
	end
	
	
end

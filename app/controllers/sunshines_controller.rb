require 'turbolinks'

class SunshinesController < ApplicationController
	protect_from_forgery with: :exception, :except => [:send_mail]
	def home
		@image_small = ProjectImage.get_project_images["s"]
		@image_large = ProjectImage.get_project_images["l"]
		@clients_logo = Client.get_client_images
		@active_status_home="active"
		@active_status_about=""
		@active_status_service=""
		@active_status_contact=""
		render :layout => 'header_footer'
	end
	
	def about
		@active_status_home=""
		@active_status_about="active"
		@active_status_service=""
		@active_status_contact=""
		render :layout => 'header_footer'
	end
	
	def contact_us
		@active_status_home=""
		@active_status_about=""
		@active_status_service=""
		@active_status_contact="active"
		render :layout => 'header_footer'
	end
	
	def send_mail
		recipient = (params[:email].to_s).strip
		customer_name=params[:name]
		message=params[:message]
		visitor_phone_str=""
		if params[:phone].present?
			visitor_phone_str="<br><br>Visitor Phone No.: #{params[:phone]}"
		end
		
		subject = "Someone is knocking..."
		encrypt_decrypt_obj=ApplicationHelper::EncryptDecrypt.new  
		user_email = encrypt_decrypt_obj.encrypt(recipient.to_s)		
		message = "<br>Welcome to Sunshine Ad Solutions.</br><br><br> Visitor Query: #{message}</br><br><br> Visitor Email: #{recipient}</br>#{visitor_phone_str}"
		UserMailer.send_mail(recipient, subject, message).deliver
		# redirect_to '/register_by_mail?status=Message sent successfully'
		# redirect_to '/home'
	end
	
	def admin_panel
	end
end

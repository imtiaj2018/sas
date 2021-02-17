require 'turbolinks'
# skip_before_action :require_login, only: [:admin_panel]


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
		recipient_mail = (params[:email].to_s).strip
		sunshine_mail="sunshineadsolutions@gmail.com"
		customer_name=params[:name]
		message=params[:message]
		visitor_phone_str=""
		if params[:phone].present?
			visitor_phone_str="<br><br>Visitor Phone No.: #{params[:phone]}"
		end
		
		sunshine_subject = "Someone is knocking..."
		recipient_subject = "Welcome to Sunshine Ad Solutions"	
		recipient_message = "<br></br>Thank you for contact us.<br> We will get back to you soon<br>"
		sunshine_message = "<br>Hi Sunshine Team,</br><br><br> Visitor Query: #{message}</br><br><br> Visitor Email: #{recipient_mail}</br>#{visitor_phone_str}"
		
		UserMailer.send_mail(recipient_mail, recipient_subject, recipient_message).deliver #send to the visiter
		# UserMailer.send_mail(sunshine_mail, sunshine_subject, sunshine_message).deliver #send to sunshine official mail id
		
		# redirect_to '/register_by_mail?status=Message sent successfully'
		# redirect_to '/home'
	end
	
	def admin_panel
		if current_user
			@current_user = current_user
		else
			redirect_to login_url
		end
	end
end

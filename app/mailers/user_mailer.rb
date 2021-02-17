class UserMailer < ApplicationMailer
	default from: 'sunshineadsolutions@gmail.com'
	
	def send_mail(user_email, subject, message) 
		Rails.logger.info "==================================="
		Rails.logger.info "============#{user_email}======================="
		Rails.logger.info "============#{subject}======================="
		Rails.logger.info "============#{message}======================="
		Rails.logger.info "========================================"
		mail(to: user_email, body: message, subject: subject, content_type: "text/html")
	end
end

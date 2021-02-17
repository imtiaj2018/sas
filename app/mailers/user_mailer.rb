class UserMailer < ApplicationMailer
	default from: 'sunshineadsolutions@gmail.com'
	
	def send_mail(user_email, subject, message) 
		Rails.logger.info "========================1==========="
		Rails.logger.info "============#{user_email}======2================="
		Rails.logger.info "============#{subject}======3================="
		Rails.logger.info "============#{message}====4==================="
		Rails.logger.info "============================5============"
		mail(to: user_email, body: message, subject: subject, content_type: "text/html")
	end
end

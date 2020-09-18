class UserMailer < ApplicationMailer
	default from: 'sunshineadsolutions@gmail.com'
	
	def send_mail(user_email, subject, message) 
		mail(to: user_email, body: message, subject: subject, content_type: "text/html")
	end
end

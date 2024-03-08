class UserMailer < ApplicationMailer
	default from: 'sunshineadsolutions@gmail.com'
	
	def send_mail(user_email, subject, message) 
		mail(to: user_email, body: message, subject: subject, content_type: "text/html")
	end
	
	def send_site_up_notification(subject, message)
		yml_data = YAML.load_file("#{Rails.root}/config/database.yml",aliases:true)
		user_email_list = yml_data["email_list"].split(',') rescue []
		mail(to: user_email_list, body: message, subject: subject, content_type: "text/html")
	end
	
	def send_attachment_email(attachment_path,user_email)
		current_time = Time.now
		formatted_time = current_time.strftime('%d-%m-%Y %H:%M:%S')
		attachments['sas_db_backup.sql'] = File.read(attachment_path)
		mail(to: user_email, subject: "SAS: Database Backup on #{formatted_time}") do |format|
			format.text { render plain: "Please find the attached file for your future reference." }
		end
	end
	
end

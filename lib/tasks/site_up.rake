require 'net/http'

namespace :chk do
	desc 'Check website status and notify via email'
	task :site_up_task => :environment do
		url = 'http://www.sunshineadsolutions.com'  # Replace with your website URL
		# url = 'http://localhost:3000/site_up'  # Replace with your website URL
		begin
			# User.check_db
			response = Net::HTTP.get_response(URI(url))
		rescue StandardError => e
			sub_line = "WEBSITE IS DOWN"
			UserMailer.send_site_up_notification("🚨#{sub_line}🚨", "Your website #{url} is down. <br><br><b>Status code</b></br></br>: #{e.message}").deliver_now
		end
	end
end

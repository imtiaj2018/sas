require 'net/http'

namespace :chk do
	desc 'Check website status and notify via email'
	task :site_up_task => :environment do
		# url = 'http://www.sunshineadsolutions.com'  # Replace with your website URL
		begin
			User.check_db
			# response = Net::HTTP.get_response(URI(url))
			
			# if response.code == '200'
				# puts "====================I am good==="
				# puts "Your website #{url} is up and running."
			# else
				# puts "====================#{response.code}"
				
			# end
		rescue StandardError => e
			# UserMailer.send_site_up_notification("Error occurred", "An error occurred while checking the website: #{e.message}").deliver_now
			sub_line = "Website is down"
			UserMailer.send_site_up_notification("🚨#{sub_line}🚨", "Your website #{url} is down. <br><br><b>Status code</b></br></br>: #{response.code}").deliver_now
		end
	end
end

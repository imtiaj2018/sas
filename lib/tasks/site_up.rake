require 'net/http'

namespace :chk do
	desc 'Check website status and notify via email'
	task :site_up_task => :environment do
		url = 'http://www.sunshineadsolutions.com'  # Replace with your website URL
		begin
			response = Net::HTTP.get_response(URI(url))
			
			if response.code == '200'
				puts "====================I am good==="
				puts "Your website #{url} is up and running."
			else
				puts "====================#{response.code}"
				UserMailer.send_site_up_notification("<div style='color: red;'><b>SAS:Website is down</b></div>", "Your website #{url} is down. <br><b>Status code</b></br>: #{response.code}").deliver_now
			end
		rescue StandardError => e
			UserMailer.send_site_up_notification("Error occurred", "An error occurred while checking the website: #{e.message}").deliver_now
		end
	end
end

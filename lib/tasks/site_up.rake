# lib/tasks/backup.rake

require 'net/http'
namespace :chk do
	desc 'Check website status and notify via email'
	task :site_up_task do
		url = 'http://www.sunshineadsolutions.com'  # Replace with your website URL
		begin
			response = Net::HTTP.get_response(URI(url))
		rescue StandardError => e
			UserMailer.send_site_up_notification("SAS Website Down", "An error occurred while checking the website: #{e.message}").deliver_now
		end
	end
end

namespace :db do
	desc 'Backup specified tables and send the dump to email'
	task :backup_and_send_mail => :environment do
		# Tables to be backed up
		tables_to_backup = %w[bill_details client_work_details brochure_pdfs clients users project_images]
		# Temporary file to store the SQL dump
		current_time = Time.now
		formatted_time = current_time.strftime('%d%m%Y%H%M%S')
		backup_file = Rails.root.join('tmp', "backup_#{formatted_time}.sql")
		config = ActiveRecord::Base.configurations[Rails.env]
		dump_cmd = "mysqldump --user=#{config['username']} --password=#{config['password']} --host=#{config['host']} #{config['database']} #{tables_to_backup.join(" ")} > #{backup_file}"
		system(dump_cmd)
		puts dump_cmd
		# Send the email with the dump file attached
		sunshine_mail="sunshineadsolutions@gmail.com"
		UserMailer.send_attachment_email(backup_file,sunshine_mail).deliver_now
		# Delete the temporary file
		File.delete(backup_file)
	end
end

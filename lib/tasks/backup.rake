# namespace :db do
	# desc 'Backup specified tables and send the dump to email'
	# task :backup_and_send_mail => :environment do
		# # Tables to be backed up
		# tables_to_backup = %w[bill_details client_work_details brochure_pdfs clients users project_images]
		# # Temporary file to store the SQL dump
		# current_time = Time.now
		# formatted_time = current_time.strftime('%d%m%Y%H%M%S')
		# backup_file = Rails.root.join('tmp', "backup_#{formatted_time}.sql")
		# config = ActiveRecord::Base.configurations[Rails.env]
		# dump_cmd = "mysqldump --user=#{config['username']} --password=#{config['password']} --host=#{config['host']} #{config['database']} #{tables_to_backup.join(" ")} > #{backup_file}"
		# system(dump_cmd)
		# puts dump_cmd
		# # Send the email with the dump file attached
		# sunshine_mail="sunshineadsolutions@gmail.com"
		# UserMailer.send_attachment_email(backup_file,sunshine_mail).deliver_now
		# # Delete the temporary file
		# File.delete(backup_file)
	# end
# end


namespace :db do
  desc 'Backup specified tables and send the dump to email'
  task backup_and_send_mail: :environment do
    begin
      # Tables to be backed up
      tables_to_backup = %w[
        bill_details
        client_work_details
        brochure_pdfs
        clients
        users
        project_images
      ]

      # Format current timestamp
      formatted_time = Time.now.strftime('%d%m%Y%H%M%S')

      # Define backup file path (in /mnt)
      backup_file = "/mnt/backup_#{formatted_time}.sql"

      # Get DB config
      config = ActiveRecord::Base.connection_db_config.configuration_hash

      # Build mysqldump command
      dump_cmd = [
        "mysqldump",
        "--user=#{Shellwords.escape(config[:username])}",
        "--password=#{Shellwords.escape(config[:password])}",
        "--host=#{Shellwords.escape(config[:host])}",
        Shellwords.escape(config[:database]),
        tables_to_backup.map { |t| Shellwords.escape(t) }.join(" "),
        "> #{Shellwords.escape(backup_file)}"
      ].join(" ")

      puts "Executing: #{dump_cmd}"
      success = system(dump_cmd)

      if success
        puts "Backup completed: #{backup_file}"

        # Send email (uncomment below line when mailer is ready)
        sunshine_mail = "sunshineadsolutions@gmail.com"
        UserMailer.send_attachment_email(backup_file, sunshine_mail).deliver_now

        # Optionally delete the backup after sending (uncomment below if needed)
        # File.delete(backup_file) if File.exist?(backup_file)
      else
        puts "Backup failed!"
      end

    rescue => e
      puts "Error during backup: #{e.message}"
      puts e.backtrace
    end
  end
end
class ClientWorkDetail < ApplicationRecord
	def self.create_client_work_details(client_work_details_create_arr=[])
		cwd= ClientWorkDetail.new
		client_work_details_create_arr.each do |e|
			cwd[e[0]]=e[1]
		end
		cwd.save
		return cwd
	end
end

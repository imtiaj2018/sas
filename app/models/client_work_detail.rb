class ClientWorkDetail < ApplicationRecord
	def self.create_client_work_details(client_work_details_create_arr=[])
		cwd= ClientWorkDetail.new
		client_work_details_create_arr.each do |e|
			cwd[e[0]]=e[1]
		end
		cwd.save
		return cwd
	end
	
	def self.get_ag_grid_data_bill_details(limit=nil)
		if limit != nil
			uplimit= limit.split('_')[1]
			lowlimit= limit.split('_')[0]
			return ClientWorkDetail.find_by_sql("SELECT * FROM client_work_details order by bill_number desc limit #{lowlimit},#{uplimit}")
		end
		return ClientWorkDetail.find_by_sql("SELECT count(*) as cc FROM client_work_details;")
	end
end

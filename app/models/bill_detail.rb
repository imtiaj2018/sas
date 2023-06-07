class BillDetail < ApplicationRecord

	def self.create_bill_details(bill_details_create_arr=[])
		bd= BillDetail.new
		bill_details_create_arr.each do |e|
			bd[e[0]]=e[1]
		end
		bd.save
		return bd
	end
end

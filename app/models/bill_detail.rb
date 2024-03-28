class BillDetail < ApplicationRecord

	def self.create_bill_details(bill_details_create_arr=[])
		bd= BillDetail.new
		bill_details_create_arr.each do |e|
			bd[e[0]]=e[1]
		end
		bd.save
		return bd
	end
	
	def self.get_chart_data
		sql_str = "SELECT 
					YEAR(STR_TO_DATE(bill_date, '%d/%m/%Y')) AS year_value, 
					MONTHNAME(STR_TO_DATE(bill_date, '%d/%m/%Y')) AS month_value,
					SUM(gross_amount) as gross_amount
				   FROM 
					client_work_details 
				   GROUP BY 
					YEAR(STR_TO_DATE(bill_date, '%d/%m/%Y')), MONTHNAME(STR_TO_DATE(bill_date, '%d/%m/%Y')) 
				   ORDER BY 
					YEAR(STR_TO_DATE(bill_date, '%d/%m/%Y')), MONTH(STR_TO_DATE(bill_date, '%d/%m/%Y'));"
		return BillDetail.find_by_sql(sql_str)
	end
end

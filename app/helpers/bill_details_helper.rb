module BillDetailsHelper
	def self.get_bill_details_grid_coldef
	
		grid_header_config_arr=[] 
		grid_header_config_arr <<  {"field" => "id","headerName"=>"ID","width" => 0,"hide" => true}
		grid_header_config_arr << {"field" => "bill_number","headerName"=>"Bill Number","width" => 150}
		grid_header_config_arr << {"field" => "job_number","headerName"=>"Job Number","width" => 150}
		grid_header_config_arr << {"field" => "payable_amount","headerName"=>"Payable Amount","width" => 150}
		grid_header_config_arr << {"field" => "gross_amount","headerName"=>"Gross Amount","width" => 150}
		grid_header_config_arr << {"field" => "bill_date","headerName"=>"Bill Date","width" => 100}
		grid_header_config_arr << {"field" => "bill_type","headerName"=>"Bill Type","width" => 100}
		grid_header_config_arr << {"field" => "bill_status","headerName"=>"Bill Status","width" => 100}
		
		return grid_header_config_arr
	end 
end

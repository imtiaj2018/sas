module BillDetailsHelper
	def self.get_bill_details_grid_coldef
	
		grid_header_config_arr=[] 
		grid_header_config_arr <<  {"field" => "id","headerName"=>"ID","width" => 0,"hide" => true,"decoration_id"=>0}
		grid_header_config_arr << {"field" => "bill_number","headerName"=>"Bill Number","width" => 150,"decoration_id"=>0}
		grid_header_config_arr << {"field" => "client_name_address","headerName"=>"Client Name","width" => 250,"decoration_id"=>0}
		grid_header_config_arr << {"field" => "job_number","headerName"=>"Job Number","width" => 210,"decoration_id"=>0}
		grid_header_config_arr << {"field" => "payable_amount","headerName"=>"Payable Amount","width" => 175,"decoration_id"=>1}
		grid_header_config_arr << {"field" => "gross_amount","headerName"=>"Gross Amount","width" => 180,"decoration_id"=>1}
		grid_header_config_arr << {"field" => "job_done_on","headerName"=>"Job Done","width" => 125,"decoration_id"=>0}
		grid_header_config_arr << {"field" => "bill_date","headerName"=>"Bill Date","width" => 125,"decoration_id"=>0}
		grid_header_config_arr << {"field" => "bill_type","headerName"=>"Bill Type","width" => 120,"decoration_id"=>0}
		grid_header_config_arr << {"field" => "bill_status","headerName"=>"Bill Status","width" => 130,"decoration_id"=>0}
		
		return grid_header_config_arr
	end 
end

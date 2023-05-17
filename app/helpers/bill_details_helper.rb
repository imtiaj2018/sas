module BillDetailsHelper
	def self.get_bill_details_grid_coldef
	
		grid_header_config_arr=[] 
		grid_header_config_arr <<  {"field" => "id","headerName"=>"ID","width" => 0,"hide" => true}
		grid_header_config_arr << {"field" => "bill_no","headerName"=>"Bill Number","width" => 150}
		grid_header_config_arr << {"field" => "bill_generate","headerName"=>"Bill Generated?","width" => 500}
		
		return grid_header_config_arr
	end 
end

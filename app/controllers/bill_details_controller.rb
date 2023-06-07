class BillDetailsController < ApplicationController
	protect_from_forgery with: :exception, :except => []
	def index
		if current_user
			@coldef = create_bill_details_coldef
			puts "======#coldef=======#{@coldef.to_json}"
		else
			redirect_to login_url
		end		
	end
	
	def createBill
		if current_user
			
		else
			redirect_to login_url
		end		
	end
	
	
	
	def create_bill_details_coldef 
		columndef_arr=[]	
		column_def_hsh={}
		column_def_hsh["headerName"]="#"
		column_def_hsh["field"]="#"
		column_def_hsh["cellStyle"]="{'text-align':'center'}"
		column_def_hsh["checkboxSelection"]=true
		column_def_hsh["pinned"]="left" 
		column_def_hsh["headerComponentParams"]={ "template"=>"<span style='padding-top:15px;'><div class='round'><input type='checkbox' class='header_chk_box' id='picb' onclick='header_select_all($(this))'><label for='picb'></label></div></span>"} 
		column_def_hsh["width"]=55
		columndef_arr << column_def_hsh 
		cell_style_hsh={}
		cell_style_hsh["text-align"]="center" 
		numeric_filter_arr = [""] 
		
		raw_data=BillDetailsHelper.get_bill_details_grid_coldef()
		raw_data.each do |obj|
			if numeric_filter_arr.include?(obj["field"])
				obj[:filter] ="agNumberColumnFilter"
			else
				obj[:filter] ="agSetColumnFilter"
			end
			obj[:cellRenderer]=obj["decoration_id"].to_s
			obj[:cellStyle] = cell_style_hsh
			columndef_arr << obj
			
		end 
		return columndef_arr 
	end
end

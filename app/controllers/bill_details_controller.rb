require 'tmpdir'

class BillDetailsController < ApplicationController
	protect_from_forgery with: :exception, :except => [:save_bill,:generate_pdf_bill,:get_bill_details_aggrid_data,:save_non_tax_bill]
	def index
		if current_user
			@coldef = create_bill_details_coldef
		else
			redirect_to login_url
		end		
	end
	
	def createBill
		if current_user
			@new_bill_number = generate_bill_number
		else
			redirect_to login_url
		end		
	end
	
	def createNonTaxBill
		if current_user
			
		else
			redirect_to login_url
		end		
	end
	
	
	def generate_bill_number
		# Retrieve the last bill number from the database
		last_bill_number_obj = ClientWorkDetail.where("bill_type = ?", 'Tax').last

		if last_bill_number_obj.nil?
			# No existing bill number in the database, start from 1
			new_bill_number = 'SAS00001'
		else
			# Extract the numeric part of the last bill number and increment it
			last_number = last_bill_number_obj.bill_number.scan(/\d+/).first.to_i
			new_number = last_number + 1

			# Format the new bill number with leading zeros
			new_bill_number = "SAS#{new_number.to_s.rjust(5, '0')}"
		end
		return new_bill_number
	end
	
	
	
	def save_bill
		oper = params[:oper]
		if oper=="add"
			client_name_address=params[:client_name_address]
			campaign_event_duration=params[:campaign]
			campaign_event_name=params[:campaign_name]
			job_done_on=params[:job_done_date]
			location=params[:locations]
			bill_number=params[:bill_no]
			bill_date=params[:bill_date]
			advanced=params[:advanced]
			additional_or_discount=params[:additinonal_charges]
			
			client_work_details_create_arr=[]
			client_work_details_create_arr<<["client_name_address",client_name_address]
			client_work_details_create_arr<<["campaign_event_duration",campaign_event_duration]
			client_work_details_create_arr<<["campaign_event_name",campaign_event_name]
			client_work_details_create_arr<<["job_done_on",job_done_on]
			client_work_details_create_arr<<["location",location]
			client_work_details_create_arr<<["bill_number",bill_number]
			client_work_details_create_arr<<["bill_date",bill_date]
			client_work_details_create_arr<<["advanced",advanced]
			client_work_details_create_arr<<["additional_or_discount",additional_or_discount]
			client_work_details_object=ClientWorkDetail.create_client_work_details(client_work_details_create_arr)
			
			if params[:specification].present?
				(0..params[:specification].length-1).each do |i| 
				
					name=params[:name][i]
					specification=params[:specification][i] 
					size=params[:size][i] 
					rate=params[:rate][i]
					qty=params[:qty][i]
					cost=params[:cost][i]
					cgst=params[:cgst][i]
					sgst=params[:sgst][i]
					gst=params[:gst][i]
					hsn=params[:hsn][i]
					tax=params[:tax][i]
					total=params[:total][i]
					
					bill_details_create_arr=[]
					bill_details_create_arr<<["bill_number",client_work_details_object.bill_number]
					bill_details_create_arr<<["name",name]
					bill_details_create_arr<<["specification",specification]
					bill_details_create_arr<<["size",size]
					bill_details_create_arr<<["rate",rate]
					bill_details_create_arr<<["qty",qty]
					bill_details_create_arr<<["cost",cost]
					bill_details_create_arr<<["cgst",cgst]
					bill_details_create_arr<<["sgst",sgst]
					bill_details_create_arr<<["gst",gst]
					bill_details_create_arr<<["hsn",hsn]
					bill_details_create_arr<<["tax",tax]
					bill_details_create_arr<<["total",total]
					
					BillDetail.create_bill_details(bill_details_create_arr) 
				end
			end 
			
			bd_obj = BillDetail.where("bill_number='#{client_work_details_object.bill_number}'")
			
			client_work_details_object.total_cost = bd_obj.collect{|x| x.cost}.sum
			client_work_details_object.total_cgst = bd_obj.collect{|x| x.cgst}.sum
			client_work_details_object.total_sgst = bd_obj.collect{|x| x.sgst}.sum
			client_work_details_object.total_tax = bd_obj.collect{|x| x.tax}.sum
			client_work_details_object.total_of_total = client_work_details_object.total_cost.to_f + client_work_details_object.total_cgst.to_f + client_work_details_object.total_sgst.to_f + client_work_details_object.total_tax.to_f
			client_work_details_object.gross_amount = (client_work_details_object.total_cost.to_f + client_work_details_object.total_tax.to_f) - client_work_details_object.additional_or_discount.to_f
			client_work_details_object.payable_amount = (client_work_details_object.gross_amount.to_f - client_work_details_object.advanced.to_f)
			client_work_details_object.save
			redirect_to :action => "index"
			
		end
	end
	
	
	def save_non_tax_bill
		oper = params[:oper]
		if oper=="add"
			client_name_address=params[:client_name_address]
			campaign_event_duration=params[:campaign]
			campaign_event_name=params[:campaign_name]
			job_done_on=params[:job_done_date]
			location=params[:locations]
			bill_number=params[:bill_no]
			bill_date=params[:bill_date]
			advanced=params[:advanced]
			additional_or_discount=params[:additinonal_charges]
			
			client_work_details_create_arr=[]
			client_work_details_create_arr<<["client_name_address",client_name_address]
			client_work_details_create_arr<<["campaign_event_duration",campaign_event_duration]
			client_work_details_create_arr<<["campaign_event_name",campaign_event_name]
			client_work_details_create_arr<<["job_done_on",job_done_on]
			client_work_details_create_arr<<["location",location]
			client_work_details_create_arr<<["bill_number",bill_number]
			client_work_details_create_arr<<["bill_date",bill_date]
			client_work_details_create_arr<<["advanced",advanced]
			client_work_details_create_arr<<["additional_or_discount",additional_or_discount]
			client_work_details_create_arr<<["bill_type","Non-TAX"]
			client_work_details_object=ClientWorkDetail.create_client_work_details(client_work_details_create_arr)
			
			if params[:specification].present?
				(0..params[:specification].length-1).each do |i| 
				
					name=params[:name][i]
					specification=params[:specification][i] 
					size=params[:size][i]
					qty=params[:qty][i]
					cost=params[:cost][i]
					total=params[:total][i]
					
					bill_details_create_arr=[]
					bill_details_create_arr<<["bill_number",client_work_details_object.bill_number]
					bill_details_create_arr<<["name",name]
					bill_details_create_arr<<["specification",specification]
					bill_details_create_arr<<["size",size]
					bill_details_create_arr<<["qty",qty]
					bill_details_create_arr<<["cost",cost]
					bill_details_create_arr<<["total",total]
					
					BillDetail.create_bill_details(bill_details_create_arr) 
				end
			end 
			
			bd_obj = BillDetail.where("bill_number='#{client_work_details_object.bill_number}'")
			
			# total_of_total = bd_obj.collect{|x| x.total}.sum
			client_work_details_object.total_of_total = bd_obj.collect{|x| x.total}.sum
			client_work_details_object.gross_amount = (client_work_details_object.total_of_total.to_f) + client_work_details_object.additional_or_discount.to_f
			client_work_details_object.payable_amount = (client_work_details_object.gross_amount.to_f - client_work_details_object.advanced.to_f)
			client_work_details_object.save
			redirect_to :action => "index"
			
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
	
	def get_bill_details_aggrid_data		
		@column_data = []
		@column_names_field=['id','bill_number','payable_amount','gross_amount','bill_date','bill_type','bill_status']
		agdata = ClientWorkDetail.get_ag_grid_data_bill_details(params[:limit])
		agdata_count = ClientWorkDetail.get_ag_grid_data_bill_details()
		agdata.each do |data|
			_tempdatahash = {}
			@column_names_field.each do |fieldname|
				if fieldname == 'bill_status'
					_tempdatahash[fieldname] = "Open"
					_tempdatahash[fieldname] = "Closed" if data.bill_status == 1
				else
					_tempdatahash[fieldname] = data[fieldname]
				end
			end	
			@column_data << _tempdatahash 
		end
		ag_data={}
		ag_data["total"]=agdata_count[0]["cc"]
		ag_data["data"]=@column_data
		render :plain =>JSON.dump(ag_data)
	end

	
	def check_generate_pdf_bill
		bill_number = params[:bill_number]
		@client_work_details = ClientWorkDetail.where("bill_number='#{bill_number}'")
		if @client_work_details[0].bill_status == 1
			render :plain =>"closed"
		else
			render :plain =>"open"
		end
		
	end
	
	def generate_pdf_bill
		options = {
			# Specify the font family you want to use
			:font_family => 'Camberia',
			:page_size => 'A4'
			# Other Wicked PDF options...
		}
	
	
	
		bill_number = params[:bill_number]
		@bill_details = BillDetail.where("bill_number='#{bill_number}'")
		@client_work_details = ClientWorkDetail.where("bill_number='#{bill_number}'")
		
		bill_template_page = 'bill_details/generate_pdf_non_tax_bill.html.erb'
		bill_template_page = 'bill_details/generate_pdf_bill.html.erb' if @client_work_details[0].bill_type.to_s.downcase == "tax"
		
		pdf = WickedPdf.new.pdf_from_string(
		  render_to_string("#{bill_template_page}", layout: false,print_media_type: true),options
		)
		
		# # Save or send the PDF as desired
		# save_path = Rails.root.join('app', 'your_pdf_file.pdf')
		# File.open(save_path, 'wb') do |file|
			# file << pdf
		# end
		
		# send_data pdf, :filename => "#{bill_number}.pdf", :type => "application/pdf", :disposition => "attachment"
		send_data pdf, :filename => "#{bill_number}.pdf", :type => "application/pdf", :disposition => "attachment"
	end

end

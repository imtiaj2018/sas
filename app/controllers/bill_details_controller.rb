require 'tmpdir'

class BillDetailsController < ApplicationController
	protect_from_forgery with: :exception, :except => [:save_bill,:generate_pdf_bill,:get_bill_details_aggrid_data,:save_non_tax_bill,:update_tax_bill, :update_non_tax_bill]
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
			@job_number = generate_job_number("tax")
		else
			redirect_to login_url
		end		
	end
	
	def createNonTaxBill
		if current_user
			@job_number = generate_job_number("non-tax")
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
	
	def generate_job_number(bill_type)
		job_number_str = ""
		current_year = Time.now.strftime("%y")
		current_month = Time.now.strftime("%m")
		next_year = current_year.to_i + 1
		
		job_number_str = "SAS/#{current_year}#{next_year}/#{current_month}#{current_year}/"
		job_number_str = "SAS/#{current_year}#{next_year}/#{current_month}#{current_year}/B" if bill_type=="tax"
		return job_number_str
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
			additional_or_discount_info=params[:additional_or_discount_info]
			
			prefix_job_number=params[:prefix_job_number]
			job_number=params[:job_number]
			exact_job_number = "#{prefix_job_number}#{job_number}"
			
			client_work_details_create_arr=[]
			client_work_details_create_arr<<["client_name_address",client_name_address]
			client_work_details_create_arr<<["additional_or_discount_info",additional_or_discount_info]
			client_work_details_create_arr<<["campaign_event_duration",campaign_event_duration]
			client_work_details_create_arr<<["campaign_event_name",campaign_event_name]
			client_work_details_create_arr<<["job_done_on",job_done_on]
			client_work_details_create_arr<<["location",location]
			client_work_details_create_arr<<["bill_number",bill_number]
			client_work_details_create_arr<<["bill_date",bill_date]
			client_work_details_create_arr<<["advanced",advanced]
			client_work_details_create_arr<<["additional_or_discount",additional_or_discount]
			client_work_details_create_arr<<["job_number",exact_job_number]
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
			client_work_details_object.total_of_total = client_work_details_object.total_cost.to_f + client_work_details_object.total_tax.to_f
			client_work_details_object.gross_amount = (client_work_details_object.total_cost.to_f + client_work_details_object.total_tax.to_f) + client_work_details_object.additional_or_discount.to_f
			client_work_details_object.payable_amount = (client_work_details_object.gross_amount.to_f - client_work_details_object.advanced.to_f)
			client_work_details_object.save
			render :plain => "success"
			
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
			additional_or_discount_info=params[:additional_or_discount_info]
			job_number=params[:job_number]
			prefix_job_number=params[:prefix_job_number]
			job_number=params[:job_number]
			exact_job_number = "#{prefix_job_number}#{job_number}"
			
			client_work_details_create_arr=[]
			client_work_details_create_arr<<["client_name_address",client_name_address]
			client_work_details_create_arr<<["additional_or_discount_info",additional_or_discount_info]
			client_work_details_create_arr<<["campaign_event_duration",campaign_event_duration]
			client_work_details_create_arr<<["campaign_event_name",campaign_event_name]
			client_work_details_create_arr<<["job_done_on",job_done_on]
			client_work_details_create_arr<<["location",location]
			client_work_details_create_arr<<["bill_number",bill_number]
			client_work_details_create_arr<<["bill_date",bill_date]
			client_work_details_create_arr<<["advanced",advanced]
			client_work_details_create_arr<<["additional_or_discount",additional_or_discount]
			client_work_details_create_arr<<["bill_type","Non-TAX"]
			client_work_details_create_arr<<["job_number",exact_job_number]
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
			client_work_details_object.total_of_total = bd_obj.collect{|x| x.total}.sum
			client_work_details_object.gross_amount = (client_work_details_object.total_of_total.to_f) + client_work_details_object.additional_or_discount.to_f
			client_work_details_object.payable_amount = (client_work_details_object.gross_amount.to_f - client_work_details_object.advanced.to_f)
			client_work_details_object.save
			render :plain => "success"
			
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
		@column_names_field=['id','bill_number','job_number','payable_amount','gross_amount','bill_date','bill_type','bill_status']
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
		bill_number = params[:bill_number]
		@bill_details = BillDetail.where("bill_number='#{bill_number}'")
		@client_work_details = ClientWorkDetail.where("bill_number='#{bill_number}'")
		client_name = @client_work_details[0].client_name_address.to_s.split("\r\n")[0]
		bill_template_page = 'bill_details/generate_pdf_non_tax_bill.html.erb'
		bill_template_page = 'bill_details/generate_pdf_bill.html.erb' if @client_work_details[0].bill_type.to_s.downcase == "tax"
		pdf = WickedPdf.new.pdf_from_string(
			render_to_string("#{bill_template_page}", layout: false,print_media_type: true)
		)
		send_data pdf, :filename => "#{client_name}_#{bill_number}.pdf", :type => "application/pdf", :disposition => "attachment"
	end
	
	
	def editTaxBill
		bill_number = params[:bill_number]
		@bill_details = BillDetail.where("bill_number='#{bill_number}'")
		@client_work_details = ClientWorkDetail.where("bill_number='#{bill_number}'")
	end
	
	def editNonTaxBill
		bill_number = params[:bill_number]
		@bill_details = BillDetail.where("bill_number='#{bill_number}'")
		@client_work_details = ClientWorkDetail.where("bill_number='#{bill_number}'")
	end
	
	
	def update_tax_bill
		oper = params[:oper]
		if oper=="edit"
			client_name_address=params[:client_name_address]
			campaign_event_duration=params[:campaign]
			campaign_event_name=params[:campaign_name]
			job_done_on=params[:job_done_date]
			location=params[:locations]
			bill_number=params[:bill_no]
			bill_date=params[:bill_date]
			advanced=params[:advanced]
			additional_or_discount=params[:additinonal_charges]
			additional_or_discount_info=params[:additional_or_discount_info]
			job_number=params[:job_number]
			
			
			client_work_details_create_arr=[]
			client_work_details_create_arr<<["client_name_address",client_name_address]
			client_work_details_create_arr<<["additional_or_discount_info",additional_or_discount_info]
			client_work_details_create_arr<<["campaign_event_duration",campaign_event_duration]
			client_work_details_create_arr<<["campaign_event_name",campaign_event_name]
			client_work_details_create_arr<<["job_done_on",job_done_on]
			client_work_details_create_arr<<["location",location]
			client_work_details_create_arr<<["bill_number",bill_number]
			client_work_details_create_arr<<["bill_date",bill_date]
			client_work_details_create_arr<<["advanced",advanced]
			client_work_details_create_arr<<["additional_or_discount",additional_or_discount]
			client_work_details_create_arr<<["job_number",job_number]
			
			generic_method_to_truncate_bill_details(bill_number,"incomplete")
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
			client_work_details_object.total_of_total = client_work_details_object.total_cost.to_f + client_work_details_object.total_tax.to_f
			client_work_details_object.gross_amount = (client_work_details_object.total_cost.to_f + client_work_details_object.total_tax.to_f) + client_work_details_object.additional_or_discount.to_f
			client_work_details_object.payable_amount = (client_work_details_object.gross_amount.to_f - client_work_details_object.advanced.to_f)
			client_work_details_object.save
			generic_method_to_truncate_bill_details(bill_number,"complete")
			render :plain => "success"
			
		end
	end
	
	
	def update_non_tax_bill
		oper = params[:oper]
		if oper=="edit"
			client_name_address=params[:client_name_address]
			campaign_event_duration=params[:campaign]
			campaign_event_name=params[:campaign_name]
			job_done_on=params[:job_done_date]
			location=params[:locations]
			bill_number=params[:bill_no]
			bill_date=params[:bill_date]
			advanced=params[:advanced]
			additional_or_discount=params[:additinonal_charges]
			additional_or_discount_info=params[:additional_or_discount_info]
			job_number=params[:job_number]
			
			client_work_details_create_arr=[]
			client_work_details_create_arr<<["client_name_address",client_name_address]
			client_work_details_create_arr<<["additional_or_discount_info",additional_or_discount_info]
			client_work_details_create_arr<<["campaign_event_duration",campaign_event_duration]
			client_work_details_create_arr<<["campaign_event_name",campaign_event_name]
			client_work_details_create_arr<<["job_done_on",job_done_on]
			client_work_details_create_arr<<["location",location]
			client_work_details_create_arr<<["bill_number",bill_number]
			client_work_details_create_arr<<["bill_date",bill_date]
			client_work_details_create_arr<<["advanced",advanced]
			client_work_details_create_arr<<["additional_or_discount",additional_or_discount]
			client_work_details_create_arr<<["bill_type","Non-TAX"]
			client_work_details_create_arr<<["job_number",job_number]
			
			generic_method_to_truncate_bill_details(bill_number,"incomplete")
			
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
			client_work_details_object.total_of_total = bd_obj.collect{|x| x.total}.sum
			client_work_details_object.gross_amount = (client_work_details_object.total_of_total.to_f) + client_work_details_object.additional_or_discount.to_f
			client_work_details_object.payable_amount = (client_work_details_object.gross_amount.to_f - client_work_details_object.advanced.to_f)
			client_work_details_object.save
			generic_method_to_truncate_bill_details(bill_number,"complete")
			render :plain => "success"
			
		end
	end
	
	def generic_method_to_truncate_bill_details(bill_number,status)
		temp_table_bill_details = "bill_details_#{bill_number.gsub('/','_')}"
		temp_table_client_work_details = "client_work_details_#{bill_number.gsub('/','_')}"
		ActiveRecord::Base.connection.execute("drop table if exists #{temp_table_bill_details};")
		ActiveRecord::Base.connection.execute("drop table if exists #{temp_table_client_work_details};")
		if(status == "incomplete")
			ActiveRecord::Base.connection.execute("create table #{temp_table_bill_details} as select * from bill_details where bill_number = '#{bill_number}'")
			ActiveRecord::Base.connection.execute("create table #{temp_table_client_work_details} as select * from client_work_details where bill_number = '#{bill_number}'")
			
			ActiveRecord::Base.connection.execute("delete from  bill_details where bill_number = '#{bill_number}'")
			ActiveRecord::Base.connection.execute("delete from  client_work_details where bill_number = '#{bill_number}'")
		end
	end
	
	
	def close_bill_and_send_mail
		sunshine_mail="sunshineadsolutions@gmail.com"
		bill_number=params[:bill_number]
		@client_work_details = ClientWorkDetail.where("bill_number='#{bill_number}'")
		sunshine_message = html_content_for_close_bill(@client_work_details)
		sunshine_subject = "#{bill_number} : Bill close notification"
		UserMailer.send_mail(sunshine_mail, sunshine_subject, sunshine_message).deliver #send to sunshine official mail id
		
		render :plain => "#{bill_number} this bill has been closed. Please check your mail for notification."
		
	end
	
	
	def html_content_for_close_bill(client_work_details)
		html_string=<<-FOO
			<table style="width: 60%; border-collapse: collapse; margin: 20px auto;">
				<tr style="border: 2px solid black;">
					<td style="width: 50%; border: 2px solid; padding: 10px;">BILL NUMBER</td>
					<td style="width: 50%; border: 2px solid; padding: 10px;">#{client_work_details[0].bill_number}</td>
				</tr>
				<tr style="border: 2px solid black;">
					<td style="width: 50%; border: 2px solid; padding: 10px;">BILL DATE</td>
					<td style="width: 50%; border: 2px solid; padding: 10px;">#{client_work_details[0].bill_date}</td>
				</tr>
				<tr style="border: 2px solid black;">
					<td style="width: 50%; border: 2px solid; padding: 10px;">CLIENT DETAILS</td>
					<td style="width: 50%; border: 2px solid; padding: 10px;">#{client_work_details[0].client_name_address}</td>
				</tr>
				<tr style="border: 2px solid black;">
					<td style="width: 50%; border: 2px solid; padding: 10px;">BILL TYPE</td>
					<td style="width: 50%; border: 2px solid; padding: 10px;">#{client_work_details[0].bill_type}</td>
				</tr>
				<tr style="border: 2px solid black;">
					<td style="width: 50%; border: 2px solid; padding: 10px;">GROSS AMOUNT</td>
					<td style="width: 50%; border: 2px solid; padding: 10px;">#{client_work_details[0].gross_amount}</td>
				</tr>
				<tr style="border: 2px solid black;">
					<td style="width: 50%; border: 2px solid; padding: 10px;">PAYABLE AMOUNT</td>
					<td style="width: 50%; border: 2px solid; padding: 10px;">#{client_work_details[0].payable_amount}</td>
				</tr>
			</table>
		FOO
		return html_string
	end
	
	def check_bill_number_for_non_tax_bill
		bill_number=params[:bill_number]
		client_work_details = ClientWorkDetail.where("bill_number='#{bill_number}' and bill_type ='Non-TAX'").take
		
		render_txt = "no"
		if client_work_details.present?
			render_txt = "yes"
		end
		render :plain => render_txt
	end
	
	def check_job_number
		prefix_job_number=params[:prefix_job_number]
		job_number=params[:job_number]
		client_work_details = ClientWorkDetail.where("job_number='#{prefix_job_number}#{job_number}'").take
		
		render_txt = "no"
		if client_work_details.present?
			render_txt = "yes@#{client_work_details.bill_number}"
		end
		render :plain => render_txt
	end

end

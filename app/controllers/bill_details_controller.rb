require 'tmpdir'

class BillDetailsController < ApplicationController
	protect_from_forgery with: :exception, :except => [:save_bill,:generate_pdf_bill]
	def index
		if current_user
			@coldef = create_bill_details_coldef
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
			client_work_details_object.gross_amount = (client_work_details_object.total_cost.to_f + client_work_details_object.total_tax.to_f) - client_work_details_object.additional_or_discount.to_f
			client_work_details_object.payable_amount = (client_work_details_object.gross_amount.to_f - client_work_details_object.advanced.to_f)
			client_work_details_object.save
			
			
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

	# def generate_pdf_bill
		# @bill_details = BillDetail.where("bill_number='123'")
		# @client_work_details = ClientWorkDetail.where("bill_number='123'")
		# pdf = WickedPdf.new.pdf_from_string(render_to_string("bill_details/generate_pdf_bill.html.erb", layout: false))
		# send_data pdf, :filename => "SAS/2324/0423/B0019.pdf", :type => "application/pdf", :disposition => "attachment"
	# end
	
	def generate_pdf_bill
		@bill_details = BillDetail.where("bill_number='123'")
		@client_work_details = ClientWorkDetail.where("bill_number='123'")
		pdf = WickedPdf.new.pdf_from_string(
		  render_to_string('bill_details/generate_pdf_bill.html.erb', layout: false),
		  pdf: {
			font_face: 'Camberia',
			font_size: 12
		  }
		)

		send_data pdf, :filename => "SAS/2324/0423/B0019.pdf", :type => "application/pdf", :disposition => "attachment"
	end

end

//===============================custom paging start=========================================
var total_row_count_gm = 0;	
var startRow_gm = 1;			
var endRow_gm = 0;					
var currentPage_gm = 0;		
var totalPage_gm = 0;			 

function load_custom_paging_gm(){ 
	var html_for_paginaton = get_pagination_html_gm(); 
	$('#group_summary_ag .ag-paging-panel').append(html_for_paginaton); 
	$("#group_summary_ag #ag_pagesize_gm").val(pageSize1_gm.toString());
	init_custom_paging_gm();	
}

function onPageSizeChanged_gm(pageSize) {		
	startRow_gm = 1;	
	endRow_gm = 0;
	currentPage_gm = 0;
	pageSize1_gm = new Number(pageSize); 
	//$('#ipgm').attr('checked', false);
	createNewDatasource_gm();
}

function init_custom_paging_gm(){		
	set_value_in_pagination_span_gm();
	init_click_event_on_pagination_gm();
}

function set_value_in_pagination_span_gm(){		
	if(totalPage_gm<1){
		$('#group_summary_ag span[ref="lbFirstRowOnPage_custom_gm"]').html(0);
	}else{
		$('#group_summary_ag span[ref="lbFirstRowOnPage_custom_gm"]').html(startRow_gm);
	}
	$('#group_summary_ag span[ref="lbLastRowOnPage_custom_gm"]').html(endRow_gm);
	$('#group_summary_ag span[ref="lbRecordCount_custom_gm"]').html(total_row_count_gm);
	$('#group_summary_ag span[ref="lbCurrent_custom_gm"]').html(currentPage_gm);
	$('#group_summary_ag span[ref="lbTotal_custom_gm"]').html(totalPage_gm);
}

function enableDisableButtons_gm(status){		
	if(status == "enable"){
		$('#group_summary_ag button[ref="btFirst_custom_gm"]').removeAttr("disabled");
		$('#group_summary_ag button[ref="btPrevious_custom_gm"]').removeAttr("disabled");
		$('#group_summary_ag button[ref="btNext_custom_gm"]').removeAttr("disabled");
		$('#group_summary_ag button[ref="btLast_custom_gm"]').removeAttr("disabled");
	}else if(status == "disable"){
		$('#group_summary_ag button[ref="btFirst_custom_gm"]').attr("disabled", "disabled");
		$('#group_summary_ag button[ref="btPrevious_custom_gm"]').attr("disabled", "disabled");
		$('#group_summary_ag button[ref="btNext_custom_gm"]').attr("disabled", "disabled");
		$('#group_summary_ag button[ref="btLast_custom_gm"]').attr("disabled", "disabled");
	}
}

function set_global_pagination_variables_gm(no_of_row){	 
	total_row_count_gm = total_aggrid_rows_gm;
	totalPage_gm = Math.ceil(total_aggrid_rows_gm/pageSize1_gm);
	if(currentPage_gm<1){
		currentPage_gm += 1;
	} 
	if(currentPage_gm==1){
		startRow_gm = 1;
	}
	endRow_gm = startRow_gm + no_of_row-1;
	set_value_in_pagination_span_gm()
}

function reset_pagination_gm(){	
	startRow_gm = 1;	
	endRow_gm = 0;
	total_row_count_gm = 0;
	currentPage_gm = 0;
	totalPage_gm = 0;
}

function init_click_event_on_pagination_gm(){	
	$(document).find('#group_summary_ag button[ref="btFirst_custom_gm"]').each(function(){
		$(this).on('click',function(){  
			if(currentPage_gm>1){
				enableDisableButtons_gm("disable");
				startRow_gm = 1;
				currentPage_gm =1;
				createNewDatasource_gm();
			}
		});
	});
	
	$(document).find('#group_summary_ag button[ref="btPrevious_custom_gm"]').each(function(){
		$(this).on('click',function(){ 
			if(currentPage_gm>1){
				enableDisableButtons_gm("disable"); 
				startRow_gm=startRow_gm-pageSize1_gm; 
				currentPage_gm -= 1;
				createNewDatasource_gm();
			}
		});
	});
	
	$(document).find('#group_summary_ag button[ref="btNext_custom_gm"]').each(function(){
		$(this).on('click',function(){ 
			if(currentPage_gm<totalPage_gm){ 
				enableDisableButtons_gm("disable"); 
				startRow_gm=startRow_gm+pageSize1_gm;
				currentPage_gm += 1;
				createNewDatasource_gm();
			}
		});
	});
	
	$(document).find('#group_summary_ag button[ref="btLast_custom_gm"]').each(function(){
		$(this).on('click',function(){
			if(currentPage_gm<totalPage_gm){
				enableDisableButtons_gm("disable"); 
				startRow_gm=(pageSize1_gm*(totalPage_gm-1))+1;
				currentPage_gm = totalPage_gm;
				createNewDatasource_gm();
			}	
		});
	});
}

function get_pagination_html_gm(){
	var content="";
	
	content += "<span ref='eSummaryPanel_custom_gm' class='ag-paging-row-summary-panel_custom'>";
	content += "<span ref='lbFirstRowOnPage_custom_gm'></span> to <span ref='lbLastRowOnPage_custom_gm'></span> of <span ref='lbRecordCount_custom_gm'></span>";
	content += "</span>";
	content += "<span class='ag-paging-page-summary-panel_custom'>";
	content += "<button type='button' class='ag-paging-button_custom' ref='btFirst_custom_gm' >First</button>";
	content += "<button type='button' class='ag-paging-button_custom' ref='btPrevious_custom_gm' >Previous</button>";
	content += "Page <span ref='lbCurrent_custom_gm'></span> of <span ref='lbTotal_custom_gm'></span>";
	content += "<button type='button' class='ag-paging-button_custom' ref='btNext_custom_gm' >Next</button>";
	content += "<button type='button' class='ag-paging-button_custom' ref='btLast_custom_gm' >Last</button>";
	content += "</span> ";   
	
	content += "<span>Page Size: ";
	content += "<select id='ag_pagesize_gm' onchange='onPageSizeChanged_gm(this.value)' class='select_for_ag'>";
	content += "<option value='10'>10</option>";
	content += "<option value='100'>100</option>";
	content += "<option value='200'>200</option>";
	content += "<option value='500'>500</option>";
	content += "<option value='1000'>1000</option>";
	content += "<option value='2000'>2000</option>";
	content += "</select>";
	content += "</span>"; 
				
	return content;
		
}
//===============================custom paging end=========================================
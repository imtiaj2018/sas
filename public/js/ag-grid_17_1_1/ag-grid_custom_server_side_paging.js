//===============================custom paging start=========================================
var total_row_count = 0;	
var startRow = 1;			
var endRow = 0;					
var currentPage = 0;		
var totalPage = 0;			 

function load_custom_paging(){ 
	var html_for_paginaton = get_pagination_html(); 
	$('.ag-paging-panel').append(html_for_paginaton); 
	$("#ag_pagesize").val(pageSize1.toString());
	init_custom_paging();	
}

function onPageSizeChanged(pageSize) {		
	startRow = 1;	
	endRow = 0;
	currentPage = 0;
	pageSize1 = new Number(pageSize); 
	$('#picb').attr('checked', false);
	createNewDatasource();
}

function init_custom_paging(){		
	set_value_in_pagination_span();
	init_click_event_on_pagination();
}

function set_value_in_pagination_span(){		
	if(totalPage<1){
		$('.ag-theme-balham span[ref="lbFirstRowOnPage_custom"]').html(0);
	}else{
		$('.ag-theme-balham span[ref="lbFirstRowOnPage_custom"]').html(startRow);
	}
	$('.ag-theme-balham span[ref="lbLastRowOnPage_custom"]').html(endRow);
	$('.ag-theme-balham span[ref="lbRecordCount_custom"]').html(total_row_count);
	$('.ag-theme-balham span[ref="lbCurrent_custom"]').html(currentPage);
	$('.ag-theme-balham span[ref="lbTotal_custom"]').html(totalPage);
}

function enableDisableButtons(status){		
	if(status == "enable"){
		$('.ag-theme-balham button[ref="btFirst_custom"]').removeAttr("disabled");
		$('.ag-theme-balham button[ref="btPrevious_custom"]').removeAttr("disabled");
		$('.ag-theme-balham button[ref="btNext_custom"]').removeAttr("disabled");
		$('.ag-theme-balham button[ref="btLast_custom"]').removeAttr("disabled");
	}else if(status == "disable"){
		$('.ag-theme-balham button[ref="btFirst_custom"]').attr("disabled", "disabled");
		$('.ag-theme-balham button[ref="btPrevious_custom"]').attr("disabled", "disabled");
		$('.ag-theme-balham button[ref="btNext_custom"]').attr("disabled", "disabled");
		$('.ag-theme-balham button[ref="btLast_custom"]').attr("disabled", "disabled");
	}
}

function set_global_pagination_variables(no_of_row){	 
	total_row_count = total_aggrid_rows;
	totalPage = Math.ceil(total_aggrid_rows/pageSize1);
	if(currentPage<1){
		currentPage += 1;
	} 
	if(currentPage==1){
		startRow = 1;
	}
	endRow = startRow + no_of_row-1;
	set_value_in_pagination_span()
}

function reset_pagination(){	
	startRow = 1;	
	endRow = 0;
	total_row_count = 0;
	currentPage = 0;
	totalPage = 0;
}

function init_click_event_on_pagination(){	
	$(document).find('.ag-theme-balham button[ref="btFirst_custom"]').each(function(){
		$(this).on('click',function(){  
			if(currentPage>1){
				enableDisableButtons("disable");
				startRow = 1;
				currentPage =1;
				createNewDatasource();
			}
		});
	});
	
	$(document).find('.ag-theme-balham button[ref="btPrevious_custom"]').each(function(){
		$(this).on('click',function(){ 
			if(currentPage>1){
				enableDisableButtons("disable"); 
				startRow=startRow-pageSize1; 
				currentPage -= 1;
				createNewDatasource();
			}
		});
	});
	
	$(document).find('.ag-theme-balham button[ref="btNext_custom"]').each(function(){
		$(this).on('click',function(){ 
			if(currentPage<totalPage){ 
				enableDisableButtons("disable"); 
				startRow=startRow+pageSize1;
				currentPage += 1;
				createNewDatasource();
			}
		});
	});
	
	$(document).find('.ag-theme-balham button[ref="btLast_custom"]').each(function(){
		$(this).on('click',function(){
			if(currentPage<totalPage){
				enableDisableButtons("disable"); 
				//startRow=total_aggrid_rows-(total_aggrid_rows%pageSize1)+1;
				startRow=(pageSize1*(totalPage-1))+1;
				currentPage = totalPage;
				createNewDatasource();
			}	
		});
	});
}

function get_pagination_html(){
	var content="";
	
	content += "<span ref='eSummaryPanel_custom' class='ag-paging-row-summary-panel_custom'>";
	content += "<span ref='lbFirstRowOnPage_custom'></span> to <span ref='lbLastRowOnPage_custom'></span> of <span ref='lbRecordCount_custom'></span>";
	content += "</span>";
	content += "<span class='ag-paging-page-summary-panel_custom'>";
	content += "<button type='button' class='ag-paging-button_custom' ref='btFirst_custom' >First</button>";
	content += "<button type='button' class='ag-paging-button_custom' ref='btPrevious_custom' >Previous</button>";
	content += "Page <span ref='lbCurrent_custom'></span> of <span ref='lbTotal_custom'></span>";
	content += "<button type='button' class='ag-paging-button_custom' ref='btNext_custom' >Next</button>";
	content += "<button type='button' class='ag-paging-button_custom' ref='btLast_custom' >Last</button>";
	content += "</span> ";   
	
	content += "<span>Page Size: ";
	content += "<select id='ag_pagesize' onchange='onPageSizeChanged(this.value)' class='select_for_ag'>";
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
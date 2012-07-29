// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

//= require jquery_ujs

var burndown_data = false;

$(document).ready(function() {
    $('.table').dataTable( {
        "sPaginationType": "scrolling"
    } );
    
    $('.edit-row-button').live('click', function() {
	    var row = $(this).closest('tr');
	    
	    var task_id = $(this).attr('data-task-id');
	    
	    var url = '/tasks/' + task_id + '/edit_row';
		
		$.get(url, function(data) {
			window['row-' + task_id] = $(row).html();
			$(row).html(data);
		});
    });
    
    $('.save-row').live('click', function(event) {
	    var row = $(this).closest('tr');
	    var task_id = $(this).attr('data-task-id');
	    
	    var form = $(row).find('form');
	    
	    $(row).html(window['row-' + task_id]);
    });
    
    $('.cancel-row').live('click', function(event) {
	    var row = $(this).closest('tr');
	    var task_id = $(this).attr('data-task-id');
	    
	    $(row).html(window['row-' + task_id]);
    });
});
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
//= require_tree .

//= require jquery_ujs

var burndown_data = false;

var row = false;

$(document).ready(function() {
	// Setup data tables
    $('.table').dataTable( {
        "sPaginationType": "scrolling"
    } );
    
    // Setup event for editing a task row
    $('.edit-row-button').live('click', function() {
	    row = $(this).closest('tr');
	    
	    var task_id = $(this).attr('data-task-id');
	    
	    var url = '/tasks/' + task_id + '/edit_row';
		
		$.get(url, function(data) {
			$('#edit-task-modal .task-form').html(data);
			$('#edit-task-modal .modal-footer .btn-primary').attr('data-task-id', task_id);
			$('#edit-task-modal').modal('show');
		});
		
		$('.edit-row-button').removeClass('active');
    });
    
    // Setup event for saving a task row
    $('.save-row').live('click', function(event) {
	    var task_id = $(this).attr('data-task-id');
	    
	    var form = $('#edit-task-modal .task-form form');
	    
	    var form_data = $(form).serialize();
	    
	    $.ajax({
	      type: 'POST',
		  url: $(form).attr('action'),
		  data: form_data,
		  dataType: "JSON",
		  success: function(data) {
			var url = '/tasks/' + task_id + '/task_row';
		
			$.get(url, function(data) {
				$(row).replaceWith(data);
				$('#edit-task-modal').modal('hide');
				$('.dropdown-toggle').dropdown()
			});
			
			burndown_data = data.burndown_data;
			target_storypoints = data.stats.target_sp;
			
			plot_burndown_data();
			
			$('#target-sp').html(data.stats.target_sp);
			
			$('#sp-complete').html(data.stats.sp_completed);
		  	  
		  	$('#percentage').html(data.stats.percentage + '% left');
		  }
		});
    });
    
    // Setup event for canceling editing a task row
    $('.cancel-row').live('click', function(event) {	    
	    $('#edit-task-modal').modal('hide');
    });
});

function plot_burndown_data() {
	// Plot burndown if available
	if (burndown_data) {
		$.plot($("#burndown"), [ burndown_data ], {
	        series: {
	            lines: { show: true },
	            points: { show: true }
	        },
	        xaxis: {
	            tickSize: 1,
	            max: sprint_days,
	            min: 0,
	            tickDecimals: 0
	        },
	        yaxis: {
		        max: target_storypoints,
		        min: 0
	        },
	        grid: {
	            backgroundColor: { colors: ["#fff", "#eee"] }
	        }
	    });
    }
}
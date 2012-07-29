$(document).ready( function() {
	$('#alert').hide();
	
	$('.dropdown-toggle').dropdown()
	
	$('#date-start')
	    .datepicker()
	    .on('changeDate', function(ev){
	        if (ev.date.valueOf() > endDate.valueOf()){
	            $('#alert').show().find('strong').text('The start date must be before the end date.');
	        } else {
	            $('#alert').hide();
	            startDate = new Date(ev.date);
	            $('#date-start-display').text($('#date-start').data('date'));
	        }
	        $('#date-start').datepicker('hide');
	    });
	$('#date-end')
	    .datepicker()
	    .on('changeDate', function(ev){
	        if (ev.date.valueOf() < startDate.valueOf()){
	            $('#alert').show().find('strong').text('The end date must be after the start date.');
	        } else {
	            $('#alert').hide();
	            endDate = new Date(ev.date);
	            $('#date-end-display').text($('#date-end').data('date'));
	        }
	        $('#date-end').datepicker('hide');
	    });
	    
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
	            min: 0
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
    
	$('.stages-toolbar a').live('click', function(){
		var stage_btn = $(this);
		var task_stage = $(this).closest('.stages-toolbar').attr('data-stage-id');
		var task_stage_status = $(this).attr('data-status');
		var task_stage_cell = $(this).closest('td');
		
		$.ajax({
		  type: 'POST',
		  url: '/sprints/change_status.json',
		  data: {
			  task_stage_id: task_stage,
			  task_stage_status: task_stage_status
		  },
		  success: function(data) {
		  	  if (task_stage_status == 'open') {
			  	$(task_stage_cell).find('.btn-info').removeClass('btn-info');
			  	$(task_stage_cell).find('.btn-success').removeClass('btn-success');
			  	$(stage_btn).addClass('btn-danger');
		  	  }
		  	  else if (task_stage_status == 'started') {
			  	$(task_stage_cell).find('.btn-danger').removeClass('btn-danger');
			  	$(task_stage_cell).find('.btn-success').removeClass('btn-success');
			  	$(stage_btn).addClass('btn-info');
		  	  }
		  	  else if (task_stage_status == 'finished') {
			  	$(task_stage_cell).find('.btn-danger').removeClass('btn-danger');
			  	$(task_stage_cell).find('.btn-info').removeClass('btn-info');
			  	$(stage_btn).addClass('btn-success');
		  	  }
		  
		  	  $('#sp-complete').html(data.sp_completed);
		  	  
		  	  $('#percentage').html(data.percentage + '% left');
		  	  
		  	  $.plot($("#burndown"), [ data.burndown_data ], {
		        series: {
		            lines: { show: true },
		            points: { show: true }
		        },
		        xaxis: {
		            tickSize: 1,
		            max: sprint_days,
		            min: 0
		        },
		        yaxis: {
			        max: data.target_sp,
			        min: 0
		        },
		        grid: {
		            backgroundColor: { colors: ["#fff", "#eee"] }
		        }
		    });
		  }
		  
		});
	});
	
	$('.remove-from-sprint').live('click', function() {
		var task_row = $(this).closest('tr');
		var task_id = $(this).attr('data-task-id');

		$.ajax({
		  type: 'GET',
		  url: '/sprints/remove_task.json',
		  dataType: 'json',
		  data: {
			  task_id: task_id
		  },
		  success: function(data) {
			  if (data.errors && data.errors.length > 0) {
				  alert('errors');
			  }
			  else {
				  $(task_row).remove();
			  }
		  }
		});
	});

});
$(document).ready( function() {
	$('.task-status-select').on('change', function(){
		var task_stage = $(this).attr('data_stage_id');
		var task_stage_status = $(this).val();
		
		$.ajax({
		  type: 'POST',
		  url: '/sprints/change_status.json',
		  data: {
			  task_stage_id: task_stage,
			  task_stage_status: task_stage_status
		  }
		});
	});
	
	$('.remove-from-sprint').on('click', function() {
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
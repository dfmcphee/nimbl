$(document).ready(function() {
	$('.add-to-sprint').on('click', function() {
		var task_row = $(this).closest('tr');
		var task_id = $(this).attr('data-task-id');
		var sprint_id = $('#task_stage_id').val();
		
		if (sprint_id) {
			$.ajax({
			  type: 'GET',
			  url: '/sprints/' + sprint_id + '/add_task.json',
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
		}
		else {
			alert('No sprint selected.');
		}
	});
	
	$('.add-to-backlog').on('click', function() {
		var task_row = $(this).closest('tr');
		var task_id = $(this).attr('data-task-id');

		$.ajax({
		  type: 'GET',
		  url: '/tasks/' + task_id + '/add_to_backlog.json',
		  dataType: 'json',
		  success: function(data) {
			  if (data.errors && data.errors.length > 0) {
				  alert('There was an error and this task could not be added to the backlog.');
			  }
			  else {
				  $(task_row).remove();
			  }
		  }
		});

	});
});
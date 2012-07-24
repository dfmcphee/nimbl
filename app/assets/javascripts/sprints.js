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
});
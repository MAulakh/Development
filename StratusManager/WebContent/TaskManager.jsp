<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta name="description" content="">
		<meta name="author" content="">

		<title>Stratus Manager</title>

		<link href="css/bootstrap.min.css" rel="stylesheet">
		<link href="css/bootstrap-theme.min.css" rel="stylesheet">
		<link href="css/style.min.css" rel="stylesheet">
		<link href="css/dashboard.css" rel="stylesheet">
		<link href="css/bootstrap-table.min1.css" rel="stylesheet">

		<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
		<!--[if lt IE 9]>
		  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->
		
   		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    	<script src="js/bootstrap.min.js"></script>
    	<script src="js/bootstrap-table.min.js"></script>
    	<script src="js/bootbox.min.js"></script>
    	<style>
    		pre {outline: 1px solid #ccc; padding: 5px; margin: 5px; }
				.string { color: green; }
				.number { color: darkorange; }
				.boolean { color: blue; }
				.null { color: magenta; }
				.key { color: red; }
    	</style>
		<script>
		
		function submitTaskConfig(){
			var dbName = selectedMapping.DBName;
        	var collName = selectedMapping.CollName;
        	var filter   = JSON.stringify(selectedMapping.Filter);
        	var workflow = selectedMapping.Workflow;
        	var config = $("#TaskConfig").get(0).value;
        	
        	$.post("services/v1/DataServices/persistConfig",
					{
						"DBName" : dbName,
						"CollName" : collName,
						"Filter" : filter,
						"Workflow" : workflow,
						"JSON" : config
					},
					function(data){
						alert("mapping persisted successfully");
					}
				);
        	
		}
		
	    $(function () {
	    	function workflowFormatter(value, row, index) {
	            return [
	                '<a class="View ml10" href="javascript:void(0)" title="View">',
	                    '<i class="glyphicon glyphicon-resize-full"></i>',
	                '</a>'
	            ].join(' ');
	        }
	    	function taskFormatter(value, row, index) {
	            return [
	                '<a class="View ml10" href="javascript:void(0)" title="View">',
	                    '<i class="glyphicon glyphicon-resize-full"></i>',
	                '</a>',
	                '<a class="Add ml10" href="javascript:void(0)" title="Add">',
                    	'<i class="glyphicon glyphicon-plus"></i>',
                	'</a>'
	            ].join(' ');
	        }
	    	function taskConfigFormatter(value, row, index) {
	            return [
	                '<a class="View ml10" href="javascript:void(0)" title="View">',
	                    '<i class="glyphicon glyphicon-resize-full"></i>',
	                '</a>'
// 	                ,
// 	                '<a class="Edit ml10" href="javascript:void(0)" title="Edit">',
//                 		'<i class="glyphicon glyphicon-edit"></i>',
//             		'</a>',
// 	                '<a class="remove ml10" href="javascript:void(0)" title="Remove">',
// 	                    '<i class="glyphicon glyphicon-remove"></i>',
// 	                '</a>'
	            ].join(' ');
	        }
	    	
	    	window.workflowEvents = {
	    			'click .View': function (e, value, row, index) {
	    				var workflow = row.EntityName;
	    				$("#table-Task").bootstrapTable('refresh', {
		            		url : 'services/v1/DataServices/getWorkflowTasks?Workflow='+workflow
		                });
		            },
	    	}
	        window.taskEvents = {
	            'click .View': function (e, value, row, index) {
	            	var entityName = row.EntityName;
	            	var workflow = row.Workflow;
	            	var entityId = row.EntityId;
	            	
	            	$("#table-TaskConfig").bootstrapTable('refresh', {
	            		url : 'services/v1/DataServices/getEntityConfigMapping?EntityName='+entityName+'&Workflow='+workflow
	                });          	        	
	            },
	            'click .Add': function (e, value, row, index) {
	            	var configId = row.ConfigId;
	            	var workflow = row.Workflow;
	            	var job = row.Job;
	            	var entityName = row.EntityName;
	            	bootbox.dialog({
	                    title: "Task Config Mapping",
	                    message: '<div class="row">  ' +
	                        '<div class="col-md-12"> ' +
	                        '<form class="form-horizontal"> ' +
	                        	'<div class="form-group"> ' +
	                        		'<label id="ConfigId" class="col-md-7 control-label" for="name">ConfigId : '+configId+'</label> '+
	                        	'</div> ' +
	                        	'<div class="form-group"> ' +
                        			'<label id="Workflow" class="col-md-7 control-label" for="name">Workflow : '+workflow+'</label> '+
                        		'</div> ' +
                        		'<div class="form-group"> ' +
                    				'<label id="Job" class="col-md-7 control-label" for="name">Job : '+job+'</label> '+
                    			'</div> ' +
                    			'<div class="form-group"> ' +
                					'<label id="EntityName" class="col-md-7 control-label" for="name">EntityName : '+entityName+'</label> '+
                				'</div> ' +
	                        	'<div class="form-group"> ' +
		                        	'<label class="col-md-4 control-label" for="name">DBName</label> ' +
		                        	'<div class="col-md-7"> ' +
		                        		'<input id="DBName" name="name" type="text" value="" placeholder="Database Name" class="form-control input-md"> ' +
		                        	'</div> ' +
		                        '</div> ' +
		                        '<div class="form-group"> ' +
		                        	'<label class="col-md-4 control-label" for="name">CollName</label> ' +
		                        	'<div class="col-md-7"> ' +
		                        		'<input id="CollName" name="name" type="text" value="" placeholder="Collection Name" class="form-control input-md"> ' +
		                        	'</div> ' +
		                        '</div> ' +
		                        '<div class="form-group"> ' +
		                        	'<label class="col-md-4 control-label" for="name">Filter</label> ' +
		                        	'<div class="col-md-7"> ' +
		                        		'<textarea id="Filter" name="name" type="text" value="" placeholder="Filters to use" class="form-control input-md"></textarea> ' +
		                        	'</div> ' +
		                        '</div> ' +
	                        '</form> </div>  </div>',
	                    buttons: {
	                        success: {
	                            label: "Save",
	                            className: "btn-success",
	                            callback: function () {
	                                var configId = $('#ConfigId').val();
	                                var entityName = $('#EntityName').val();
	                                var workflow = $('#Workflow').val();
	                                var job = $('#Job').val();
	                                var dbName = $('#DBName').val();
	                                var collName = $('#CollName').val();
	                                var filter = $('#Filter').val();
	                                var json = {
	                                	"ConfigId" : configId,
	                                	"Workflow" : workflow,
	                                	"EntityName" : entityName,
	                                	"Job" : job,
	                                	"DBName" : dbName,
	                                	"CollName" : collName,
	                                	"Filter" : filter
	                                };
	                                $.ajax(
	            	        				{
	            	        					url:"services/v1/DataServices/persistTaskConfigMapping?ConfigId="+configId+"&JSON="+JSON.stringify(json),
	            	        					success:function(data){
	            	        						bootbox.alert("Action : "+data, function() {});
	            	        					}
	            	        				}
	            	        			);
	                            }
	                        }
	                    }
	                }
	            	);
	           	}
	        };
	    	window.taskConfigEvents = {
		            'click .View': function (e, value, row, index) {
// 		            	var dbName = row.DBName;
// 		            	var collName = row.CollName;
// 		            	var filter = JSON.stringify(row.Filter);
// 		            	var configId = row.ConfigId;
						var entityName = row.EntityName;
						var workflow = row.Workflow;
						var jobGroup = row.JobGroup;
						var job = row.Job;
						var taskId = row.EntityId;
		            	
		            	$.ajax(
		        				{
// 		        					url:"services/v1/DataServices/getData?DBName="+dbName+"&CollName="+collName+"&Filter="+filter,
									url:"services/v1/DataServices/getEntityConfigMapping?EntityName="+entityName+"&Workflow="+workflow+"&JobGroup="+jobGroup+"&Job="+job,
		        					success:function(data){
		        						$("#TaskConfig").get(0).value = JSON.stringify(JSON.parse(data), undefined, 4);
		        						$("#TaskConfig-ConfigId").get(0).innerHTML = "TaskId : "+taskId;
		        					}
		        				}
		        			);         	        	
		            }
// 	    	,
// 		            'click .Edit': function (e, value, row, index) {
// 		            	var configId = row.ConfigId;
// 		            	var workflow = row.Workflow;
// 		            	var job = row.Job;
// 		            	var entityName = row.EntityName;
// 		            	var dbName = row.DBName;
// 		            	var collName = row.CollName;
// 		            	var filter = JSON.stringify(row.Filter, undefined, 4);
// 		            	bootbox.dialog({
// 		                    title: "Task Config Mapping",
// 		                    message: '<div class="row">  ' +
// 		                        '<div class="col-md-12"> ' +
// 		                        '<form class="form-horizontal"> ' +
// 		                        	'<div class="form-group"> ' +
// 		                        		'<label id="ConfigId" class="col-md-7 control-label" for="name">ConfigId : '+configId+'</label> '+
// 		                        	'</div> ' +
// 		                        	'<div class="form-group"> ' +
// 	                        			'<label id="Workflow" class="col-md-7 control-label" for="name">Workflow : '+workflow+'</label> '+
// 	                        		'</div> ' +
// 	                        		'<div class="form-group"> ' +
//                         				'<label id="Job" class="col-md-7 control-label" for="name">Job : '+job+'</label> '+
//                         			'</div> ' +
//                         			'<div class="form-group"> ' +
//                     					'<label id="EntityName" class="col-md-7 control-label" for="name">EntityName : '+entityName+'</label> '+
//                     				'</div> ' +
// 		                        	'<div class="form-group"> ' +
// 			                        	'<label class="col-md-4 control-label" for="name">DBName</label> ' +
// 			                        	'<div class="col-md-7"> ' +
// 			                        		'<input id="DBName" name="name" type="text" value="'+dbName+'" placeholder="Database Name" class="form-control input-md"> ' +
// 			                        	'</div> ' +
// 			                        '</div> ' +
// 			                        '<div class="form-group"> ' +
// 			                        	'<label class="col-md-4 control-label" for="name">CollName</label> ' +
// 			                        	'<div class="col-md-7"> ' +
// 			                        		'<input id="CollName" name="name" type="text" value="'+collName+'" placeholder="Collection Name" class="form-control input-md"> ' +
// 			                        	'</div> ' +
// 			                        '</div> ' +
// 			                        '<div class="form-group"> ' +
// 			                        	'<label class="col-md-4 control-label" for="name">Filter</label> ' +
// 			                        	'<div class="col-md-7"> ' +
// 			                        		'<textarea id="Filter" name="name" type="text" value="'+filter+'" placeholder="Filters to use" class="form-control input-md">'+filter+'</textarea> ' +
// 			                        	'</div> ' +
// 			                        '</div> ' +
// 		                        '</form> </div>  </div>',
// 		                    buttons: {
// 		                        success: {
// 		                            label: "Save",
// 		                            className: "btn-success",
// 		                            callback: function () {
// 		                                var configId = $('#ConfigId').val();
// 		                                var entityName = $('#EntityName').val();
// 		                                var workflow = $('#Workflow').val();
// 		                                var job = $('#Job').val();
// 		                                var dbName = $('#DBName').val();
// 		                                var collName = $('#CollName').val();
// 		                                var filter = $('#Filter').val();
// 		                                var json = {
// 		                                	"ConfigId" : configId,
// 		                                	"Workflow" : workflow,
// 		                                	"EntityName" : entityName,
// 		                                	"Job" : job,
// 		                                	"DBName" : dbName,
// 		                                	"CollName" : collName,
// 		                                	"Filter" : filter
// 		                                };
// 		                                $.ajax(
// 		            	        				{
// 		            	        					url:"services/v1/DataServices/persistTaskConfigMapping?ConfigId="+configId+"&JSON="+JSON.stringify(json),
// 		            	        					success:function(data){
// 		            	        						bootbox.alert("Action : "+data, function() {});
// 		            	        					}
// 		            	        				}
// 		            	        			);
// 		                            }
// 		                        }
// 		                    }
// 		                }
// 		            );
// 		            },
// 		            'click .Remove': function (e, value, row, index) {
// 		                alert('You click remove icon, row: ' + JSON.stringify(row));
// 		                console.log(value, row, index);
// 		            }
		        };
	    	
	    	$('#table-TaskConfig').bootstrapTable({
	            method: 'get',
	            height: 400,
	        	striped: true,
	            pagination: true,
	            pageSize: 10,
	            pageList: [10, 25, 50, 100, 200],
	            search: true,
	            showColumns: true,
	            showRefresh: true,
	            clickToSelect: true,
	            columns: [{
	                field: 'ConfigId',
	                title: 'ConfigId',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'Workflow',
	                title: 'Workflow',
	                align: 'center',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'Job',
	                title: 'Job',
	                align: 'center',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'EntityName',
	                title: 'EntityName',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'DBName',
	                title: 'DBName',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'CollName',
	                title: 'CollName',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'operate',
	                title: 'Item Operate',
	                align: 'center',
	                valign: 'middle',
	                clickToSelect: false,
	                formatter: taskConfigFormatter,
	                events: taskConfigEvents
	            }]
	        });
	        $('#table-Task').bootstrapTable({
	            method: 'get',
	            height: 400,
	        	striped: true,
	            pagination: true,
	            pageSize: 10,
	            pageList: [10, 25, 50, 100, 200],
	            search: true,
	            showColumns: true,
	            showRefresh: true,
	            clickToSelect: true,
	            columns: [{
	                field: 'EntityId',
	                title: 'EntityId',
	                align: 'right',
	                valign: 'bottom',
	                sortable: true
	            }, {
	                field: 'Workflow',
	                title: 'Workflow',
	                align: 'center',
	                valign: 'middle',
	                sortable: true
	            },{
	                field: 'JobGroup',
	                title: 'JobGroup',
	                align: 'center',
	                valign: 'middle',
	                sortable: true
	            },{
	                field: 'Job',
	                title: 'Job',
	                align: 'center',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'EntityName',
	                title: 'EntityName',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'operate',
	                title: 'Item Operate',
	                align: 'center',
	                valign: 'middle',
	                clickToSelect: false,
// 	                formatter: taskFormatter,
// 	                events: taskEvents
	                formatter: taskConfigFormatter,
	                events: taskConfigEvents
	            }]
	        });
	        $('#table-Workflow').bootstrapTable({
	            method: 'get',
	            url: 'services/v1/DataServices/getWorkflowDetails?EntityName=',
	            height: 400,
	        	striped: true,
	            pagination: true,
	            pageSize: 10,
	            pageList: [10, 25, 50, 100, 200],
	            search: true,
	            showColumns: true,
	            showRefresh: true,
	            clickToSelect: true,
	            columns: [{
	                field: 'EntityId',
	                title: 'EntityId',
	                align: 'right',
	                valign: 'bottom',
	                sortable: true
	            }, {
	                field: 'ClassName',
	                title: 'ClassName',
	                align: 'center',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'EntityName',
	                title: 'EntityName',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'EntityType',
	                title: 'EntityType',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'operate',
	                title: 'Item Operate',
	                align: 'center',
	                valign: 'middle',
	                clickToSelect: false,
	                formatter: workflowFormatter,
	                events: workflowEvents
	            }]
	        });
	    });
	</script>
	</head>
	<body>

    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Stratus Manager</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="#">Dashboard</a></li>
            <li><a href="#">Settings</a></li>
            <li><a href="#">Profile</a></li>
            <li><a href="#">Help</a></li>
          </ul>
          <form class="navbar-form navbar-right">
            <input type="text" class="form-control" placeholder="Search...">
          </form>
        </div>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
          <ul class="nav nav-sidebar">
            <li><a href="WorkflowManager.jsp">WorkflowManager</a></li>
            <li><a href="CreateWorkflow.jsp">CreateWorkflow</a></li>
            <li><a href="EditWorkflow.jsp">EditWorkflow</a></li>
            <li><a href="#">WorkflowGraph</a></li>
          </ul>
          <ul class="nav nav-sidebar">
            <li class="active" ><a href="#">TaskManager</a></li>
          </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">  
        	<h2 class="sub-header">TaskMapping</h2>        
          	<div class="row placeholders">
          		<table id="table-Workflow" class="table" data-show-toggle="true"></table>
          		<table id="table-Task" class="table" data-show-toggle="true"></table>
          		<div class="form-group">
	          		<label class="col-sm-2 control-label" id="TaskConfig-ConfigId">TaskId :</label>
          		</div>
	        	<textarea rows="25" class="form-control" id="TaskConfig"></textarea>
<!-- 	        	<table id="table-TaskConfig" class="table" data-show-toggle="true"></table> -->
	        	<button type="button" class="btn btn-default" onclick="submitTaskConfig()">Submit</button>
          	</div>
        </div>
      </div>
    </div>

</body>
</html>
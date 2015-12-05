<!DOCTYPE html>
<%@page import="com.stratus.manager.services.DataServices"%>
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
    	<script src="js/jstree.min.js"></script>
    	<script src="js/bootbox.min.js"></script>
    	
	<script>
		function submitWorkflow(){
			
			var workflowMappingFromTree = $('#jstree_WorkflowMapping').jstree(true).get_json();
// 			alert(JSON.stringify(workflowMappingFromTree));

			var client = workflowMappingFromTree[0].data.Client;
			var workflowName = workflowMappingFromTree[0].data.Workflow;
			console.log(JSON.stringify(workflowMappingFromTree))
			var workflowMapping = deriveMappingsFromJsTree(client, workflowName, workflowMappingFromTree);
			console.log("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
			console.log(JSON.stringify(workflowMapping));
// 			alert("Going to persist details...!!!");
// 			$.ajax(
// 				{
// 					url:"services/v1/DataServices/removeMapping?Workflow="+workflowName,
// 					success:function(data){
// 						alert("details persisted successfully");
// 					}
// 				}
// 			);
			$.post("services/v1/DataServices/persistMappings",
					{
						"Workflow" : workflowName,
						"JSON" : JSON.stringify(workflowMapping)
					},
					function(data){
						alert("mapping persisted successfully");
					}
				);
		}
		
		function deriveMappingsFromJsTree(client, workflowName, mappingListFromJSTree){
			
			var mappingArray = new Array();
			var childrenMapping = new Array();
			
			for(var i=0; i<mappingListFromJSTree.length; i++){
				
				var mappingFromJSTree = mappingListFromJSTree[i];
			
				var mappingDetails = mappingFromJSTree.data;
				
				if(mappingDetails.EntityType == "Task"){
					continue;
				}
				
				var mapping = {
						"Client" : client,
						"EntityId" : mappingDetails.EntityId,
						"EntityName" : mappingDetails.EntityName,
						"EntityType" : mappingDetails.EntityType,
						"Workflow" : workflowName
				}
				var children = getChildren(mappingFromJSTree);
				mapping.SubTypesList = children;
				
				mappingArray[i] = mapping;
				
// 				for(var j=0; j<mappingFromJSTree.children.length; j++){
					var childMappings = deriveMappingsFromJsTree(client, workflowName, mappingFromJSTree.children);
					if(childMappings!=null && childMappings.length!=0){
						childrenMapping = childrenMapping.concat(childMappings);
					}
					else{
						alert("children were null");
					}
// 				}
			
			}
			var result = mappingArray.concat(childrenMapping);
// 			alert(JSON.stringify(result));
			return result;
		}
		
		function getChildren(mappingFromJSTree){
			var childrenArray = new Array();
			if(mappingFromJSTree.children==null || mappingFromJSTree.children.length==0){
				return childrenArray;
			}
			for(var i=0; i<mappingFromJSTree.children.length; i++){
				var childMap = mappingFromJSTree.children[i];
				var toAdd = {
						"EntityId" : parseInt(childMap.data.EntityId),
						"EntityName" : childMap.data.EntityName,
						"Sequence" : parseInt(i)
				}
				childrenArray[i] = toAdd;
			}
			return childrenArray
		}
		
		function init_tree(data){
			
			if(data==null){
				data = [
						{
							"text" : "WorkflowMapping",
							"type" : "Workflow",
							'state' : {
						     	'opened' : true,
						        'selected' : true
						     }
						}
					];
			}
			
			$('#jstree_WorkflowMapping')
			.jstree({
				"core" : {
					"animation" : 300,
					"check_callback" : true,
					"themes" : { "stripes" : true },
					'data' : data
				},
				"types" : {
					"#" : { "max_children" : 1, "max_depth" : 4, "valid_children" : ["root"] },
					"Workflow" : { "icon" : "glyphicon glyphicon-th-large", "valid_children" : ["JobGroup"] },
					"JobGroup" : { "icon" : "glyphicon glyphicon-th-list", "valid_children" : ["Job"] },
					"Job" : { "icon" : "glyphicon glyphicon-book", "valid_children" : ["Task"] },
					"Task" : { "icon" : "glyphicon glyphicon-file", "valid_children" : [] },
				},
				"plugins" : [ "contextmenu", "dnd", "search", "state", "types", "wholerow" ]
			});
		}
		
	    $(function () {
	    	
	    	init_tree();
	    	
	    	function operateFormatter(value, row, index) {
	            return [
	                '<a class="Add ml10" href="javascript:void(0)" title="Add">',
	                    '<i class="glyphicon glyphicon glyphicon-plus"></i>',
	                '</a>',
	                '<a class="Edit ml10" href="javascript:void(0)" title="Edit">',
                    	'<i class="glyphicon glyphicon glyphicon-edit"></i>',
                	'</a>'
	            ].join(' ');
	        }
	    	function entityOperateFormatter(value, row, index) {
	            return [
	                '<a class="Edit ml10" href="javascript:void(0)" title="Edit">',
                    	'<i class="glyphicon glyphicon glyphicon-edit"></i>',
                	'</a>',
	                '<a class="Remove ml10" href="javascript:void(0)" title="Remove">',
                    	'<i class="glyphicon glyphicon-remove"></i>',
                	'</a>'
	            ].join(' ');
	        }

	        window.operateEvents = {
	            'click .Edit': function (e, value, row, index) {
	            	var entityType = row.EntityType;
	            	var entityName = row.EntityName;
	            	var workflow   = row.Workflow;
	            	var mapping;
	            	if(entityType=="Workflow"){
	            		workflow = entityName;
	            	}
	            	else{
	            		alert("Select workflow !!!");
	            		return;
	            	}
	            	
	            	$.ajax(
	        				{
	        					url:"services/v1/DataServices/getWorkflowMapping?Workflow="+workflow,
	        					success:function(data){
	        						mapping = JSON.parse(data);
	        						var jsTreeFormat = {}
	        		            	
	        		            	var jobs = getJobsMapInJSTreeFormat(mapping);
	        		            	var jobGroups = getJobGroupsMapInJSTreeFormat(jobs, mapping);
									var workflow = getWorkflowInJSTreeFormat(jobGroups, mapping);
	        						
	        						$("#jstree_WorkflowMapping").jstree('destroy');
	        						init_tree(workflow);
	        					}
	        				}
	        			);
	            },
	        	'click .Add': function (e, value, row, index) {
	            	var entityType = row.EntityType;
	            	var entityName = row.EntityName;
	            	var workflow   = row.Workflow;
	            	var table;
	            	
	            	if(entityType=="Workflow"){
	            		table = "table-JobGroup";
	            		workflow = entityName;
	            	}
	            	else if(entityType=="JobGroup"){
	            		table = "table-Job";
	            	}
	            	else if(entityType=="Job"){
	            		table = "table-Task";
	            	}
	//	            	alert("Table==>>"+table+" Entityname==>>"+entityName+" Workflow==>>"+workflow);
	            	
	            	var ref = $('#jstree_WorkflowMapping').jstree(true),
					sel = ref.get_selected();
					if(!sel.length) { return false; }
					sel = sel[0];
					var node = {
						"text":entityName,
						"type":entityType,
						"data":row
					}
					sel = ref.create_node(sel, node);
	            }
	        };
	        window.entityOperateEvents = {
		            'click .Edit': function (e, value, row, index) {
		            	var entityId = row.EntityId;
		            	var entityType = row.EntityType;
		            	var entityName = row.EntityName;
		            	var className = row.ClassName;
		            	var dataType = row.DataType;
		            	var mapping;
		            	bootbox.dialog({
		                    title: "Entity Details",
		                    message: '<div class="row">  ' +
		                        '<div class="col-md-12"> ' +
		                        '<form class="form-horizontal"> ' +
		                        	'<div class="form-group"> ' +
		                        		'<label id="EntityId" class="col-md-4 control-label" for="name">EntityId : '+entityId+'</label> '+
		                        	'</div> ' +
		                        	'<div class="form-group"> ' +
			                        	'<label class="col-md-4 control-label" for="name">EntityType</label> ' +
			                        	'<div class="col-md-7"> ' +
			                        		'<input id="EntityType" name="name" type="text" value="'+entityType+'" placeholder="e.g. Task/Workflow" class="form-control input-md"> ' +
			                        	'</div> ' +
			                        '</div> ' +
			                        '<div class="form-group"> ' +
			                        	'<label class="col-md-4 control-label" for="name">EntityName</label> ' +
			                        	'<div class="col-md-7"> ' +
			                        		'<input id="EntityName" name="name" type="text" value="'+entityName+'" placeholder="EntityName" class="form-control input-md"> ' +
			                        	'</div> ' +
			                        '</div> ' +
			                        '<div class="form-group"> ' +
			                        	'<label class="col-md-4 control-label" for="name">ClassName</label> ' +
			                        	'<div class="col-md-7"> ' +
			                        		'<input id="ClassName" name="name" type="text" value="'+className+'" placeholder="Binary Class Path" class="form-control input-md"> ' +
			                        	'</div> ' +
			                        '</div> ' +
			                        '<div class="form-group"> ' +
			                        	'<label class="col-md-4 control-label" for="name">DataType</label> ' +
			                        	'<div class="col-md-7"> ' +
			                        		'<input id="DataType" name="name" type="text" value="'+dataType+'" placeholder="e.g. COC/Position" class="form-control input-md"> ' +
			                        	'</div> ' +
			                        '<div class="form-group"> ' +
		                        '</form> </div>  </div>',
		                    buttons: {
		                        success: {
		                            label: "Save",
		                            className: "btn-success",
		                            callback: function () {
		                                var entityType = $('#EntityType').val();
		                                var entityName = $('#EntityName').val();
		                                var className = $('#ClassName').val();
		                                var dataType = $('#DataType').val();
		                                var json = {
		                                	"EntityId" : entityId,
		                                	"EntityType" : entityType,
		                                	"EntityName" : entityName,
		                                	"ClassName" : className,
		                                	"DataType" : dataType,
		                                };
		                                $.ajax(
		            	        				{
		            	        					url:"services/v1/DataServices/persistDetails?EntityId="+entityId+"&JSON="+JSON.stringify(json),
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
	        
	        function getWorkflowInJSTreeFormat(jobGroupsMap, mapping){
	        	var workflowArr = new Array();
	        	var count=0;
	        	for(var i=0; i<mapping.length; i++){
	        		var map = mapping[i];
	        		if(map.EntityType=="Workflow"){
	        			var workflowName = map.EntityName;
	        			var workflow = {
	        					text:workflowName,
	        					type:map.EntityType,
	        					data:map
	        			}
	        			var jobGroups = new Array();
	        			for(var j=0; j<map.SubTypesList.length; j++){
	        				var jobGroupMap = map.SubTypesList[j];
	        				jobGroups[j] = jobGroupsMap[jobGroupMap.EntityName];
	        			}
	        			workflow.children = jobGroups;
	        			workflowArr[count] = workflow;
	        			count++;
	        		}
	        	}
	        	return workflowArr;
	        }
	        
	        function getJobGroupsMapInJSTreeFormat(jobsMap, mapping){
	        	var jobGroupsMap = {};
	        	for(var i=0; i<mapping.length; i++){
	        		var map = mapping[i];
	        		if(map.EntityType=="JobGroup"){
	        			var jobGroupName = map.EntityName;
	        			var jobGroup = {
	        					text:jobGroupName,
	        					type:map.EntityType,
	        					data:map
	        			}
	        			var jobs = new Array();
	        			for(var j=0; j<map.SubTypesList.length; j++){
	        				var jobMap = map.SubTypesList[j];
	        				jobs[j] = jobsMap[jobMap.EntityName];
	        			}
	        			jobGroup.children = jobs;
	        			jobGroupsMap[jobGroupName] = jobGroup;
	        		}
	        	}
	        	return jobGroupsMap;
	        }
	        
	        function getJobsMapInJSTreeFormat(mapping){
	        	var jobsMap = {};
	        	for(var i=0; i<mapping.length; i++){
	        		var map = mapping[i];
	        		if(map.EntityType=="Job"){
	        			var jobName = map.EntityName;
	        			var job = {
	        					text:jobName,
	        					type:map.EntityType,
	        					data:map
	        			}
	        			var tasks = new Array();
	        			for(var j=0; j<map.SubTypesList.length; j++){
	        				var taskMap = map.SubTypesList[j];
	        				taskMap.EntityType = "Task";
	        				
	        				var taskMapInJSTreeFormat = {};
	        				taskMapInJSTreeFormat.text = taskMap.EntityName;
	        				taskMapInJSTreeFormat.type = "Task";
	        				taskMapInJSTreeFormat.data = taskMap;
	        				tasks[j] = taskMapInJSTreeFormat;
	        			}
						
        				job.children = tasks;
        				jobsMap[jobName] = job;
	        		}
	        	}
	        	return jobsMap;
	        }
	        
	        $('#table-Workflows').bootstrapTable({
	            method: 'get',
	            url: 'services/v1/DataServices/getDetails',
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
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'ClassName',
	                title: 'ClassName',
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'EntityName',
	                title: 'EntityName',
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'EntityType',
	                title: 'EntityType',
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'DataType',
	                title: 'DataType',
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'operate',
	                title: 'Item Operate',
	                align: 'left',
	                valign: 'middle',
	                clickToSelect: false,
	                formatter: operateFormatter,
	                events: operateEvents
	            }]
	        });
	        
	        $('#table-EntityDetails').bootstrapTable({
	            method: 'get',
	            url: 'services/v1/DataServices/getDetails',
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
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'ClassName',
	                title: 'ClassName',
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'EntityName',
	                title: 'EntityName',
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'EntityType',
	                title: 'EntityType',
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'DataType',
	                title: 'DataType',
	                align: 'left',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'operate',
	                title: 'Item Operate',
	                align: 'left',
	                valign: 'middle',
	                clickToSelect: false,
	                formatter: entityOperateFormatter,
	                events: entityOperateEvents
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
            <li class="active"><a href="#">EditWorkflow</a></li>
            <li><a href="#">WorkflowGraph</a></li>
          </ul>
          <ul class="nav nav-sidebar">
            <li><a href="TaskManager.jsp">TaskManager</a></li>
          </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">            	
          	<h2 class="sub-header">Edit Workflow Mapping</h2>        
          	<div class="row placeholders">
          		
          		<div id="custom-toolbar">
          			<div class="form-horizontal" role="form">
          				<div class="form-group">
	          				<div id="jstree_WorkflowMapping" style="text-align:left"></div>
	          			</div>
          			</div>
          		</div>
	        	<table id="table-Workflows" class="table" data-show-toggle="true"></table>
	        	<button type="button" class="btn btn-default" onclick="submitWorkflow()">Submit</button>
          	</div>
          	
          	<h2 class="sub-header">Edit Entity Details</h2>        
          	<div class="row placeholders">
	        	<table id="table-EntityDetails" class="table" data-show-toggle="true"></table>
          	</div>
        </div>
      </div>
    </div>

</body>
</html>
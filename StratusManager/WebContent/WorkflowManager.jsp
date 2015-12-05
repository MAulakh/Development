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
		<script>
	    $(function () {
	    	function operateFormatter(value, row, index) {
	            return [
	                '<a class="View ml10" href="javascript:void(0)" title="View">',
	                    '<i class="glyphicon glyphicon-resize-full"></i>',
	                '</a>',
	                '<a class="edit ml10" href="javascript:void(0)" title="Edit">',
	                    '<i class="glyphicon glyphicon-edit"></i>',
	                '</a>',
	                '<a class="remove ml10" href="javascript:void(0)" title="Remove">',
	                    '<i class="glyphicon glyphicon-remove"></i>',
	                '</a>'
	            ].join(' ');
	        }

	        window.operateEvents = {
	            'click .View': function (e, value, row, index) {
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
// 	            	alert("Table==>>"+table+" Entityname==>>"+entityName+" Workflow==>>"+workflow);
	            	
	            	$('#'+table).bootstrapTable('refresh', {
	            		url : "services/v1/DataServices/getSubTypeMappingDetails?EntityName="+entityName+"&Workflow="+workflow
	                });
	            },
	            'click .edit': function (e, value, row, index) {
	                alert('You click edit icon, row: ' + JSON.stringify(row));
	                console.log(value, row, index);
	            },
	            'click .remove': function (e, value, row, index) {
	                alert('You click remove icon, row: ' + JSON.stringify(row));
	                console.log(value, row, index);
	            }
	        };
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
	                formatter: operateFormatter,
	                events: operateEvents
	            }]
	        });
	        $('#table-JobGroup').bootstrapTable({
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
	                field: 'Sequence',
	                title: 'Sequence',
	                align: 'center',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'Client',
	                title: 'Client',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'EntityName',
	                title: 'EntityName',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'Workflow',
	                title: 'Workflow',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'operate',
	                title: 'Item Operate',
	                align: 'center',
	                valign: 'middle',
	                clickToSelect: false,
	                formatter: operateFormatter,
	                events: operateEvents
	            }]
	        });
	        
	        $('#table-Job').bootstrapTable({
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
	                field: 'Sequence',
	                title: 'Sequence',
	                align: 'center',
	                valign: 'middle',
	                sortable: true
	            }, {
	                field: 'Client',
	                title: 'Client',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'EntityName',
	                title: 'EntityName',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'Workflow',
	                title: 'Workflow',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'operate',
	                title: 'Item Operate',
	                align: 'center',
	                valign: 'middle',
	                clickToSelect: false,
	                formatter: operateFormatter,
	                events: operateEvents
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
	                field: 'Sequence',
	                title: 'Sequence',
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
	                field: 'Workflow',
	                title: 'Workflow',
	                align: 'left',
	                valign: 'top',
	                sortable: true
	            }, {
	                field: 'operate',
	                title: 'Item Operate',
	                align: 'center',
	                valign: 'middle',
	                clickToSelect: false,
	                formatter: operateFormatter,
	                events: operateEvents
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
            <li class="active"><a href="#">WorkflowManager</a></li>
            <li><a href="CreateWorkflow.jsp">CreateWorkflow</a></li>
            <li><a href="EditWorkflow.jsp">EditWorkflow</a></li>
            <li><a href="#">WorkflowGraph</a></li>
          </ul>
          <ul class="nav nav-sidebar">
            <li><a href="TaskManager.jsp">TaskManager</a></li>
          </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">  
        	<h2 class="sub-header">Workflows</h2>        
          	<div class="row placeholders">
	        	<table id="table-Workflow" class="table" data-show-toggle="true"></table>
          	</div>
          	
          	<h2 class="sub-header">JobGroups</h2>        
          	<div class="row placeholders">
	        	<table id="table-JobGroup" class="table" data-show-toggle="true"></table>
          	</div>
          	
          	<h2 class="sub-header">Jobs</h2>        
          	<div class="row placeholders">
	        	<table id="table-Job" class="table" data-show-toggle="true"></table>
          	</div>
          	
          	<h2 class="sub-header">Tasks</h2>        
          	<div class="row placeholders">
	        	<table id="table-Task" class="table" data-show-toggle="true"></table>
          	</div>
        </div>
      </div>
    </div>

</body>
</html>
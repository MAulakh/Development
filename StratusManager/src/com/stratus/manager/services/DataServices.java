package com.stratus.manager.services;

import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import javax.ws.rs.*;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.WriteConcern;
import com.mongodb.util.JSON;
import com.stratus.manager.mongoconnection.MongoConnection;

@Path("/v1/DataServices/")
public class DataServices {
	
	private String JOBS_DB = "jobs_db";
	private String LOADER_ENTITY_DETAILS_COLL = "loader_entity_details_coll_v2";
	private String CLIENT_DB = "stonebridge_config_db";
	private String LOADER_ENTITY_MAPPING_COLL = "stonebridge_loader_entity_mapping_config_coll";
//	private String LOADER_ENTITY_MAPPING_COLL = "stonebridge_loader_entity_mapping_config_coll_backup_07052015";
//	private String LOADER_ENTITY_MAPPING_COLL = "loader_entity_mapping_config";
	private String TASK_CONFIG = "stonebridge_task_config_coll";
	
	@Path("/getDetails")
	@GET
	@Produces("text/JSON")
	public String getDetails() throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(JOBS_DB).getCollection(LOADER_ENTITY_DETAILS_COLL);
		DBCursor cur = coll.find();
		List<Map> toReturn = new ArrayList();
		while(cur.hasNext()){
			toReturn.add(cur.next().toMap());
		}
		return JSON.serialize(toReturn);
	}

	@Path("/getWorkflowDetails")
	@GET
	@Produces("text/JSON")
	public String getWorkflowDetails(@QueryParam("EntityName")String entityName) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(JOBS_DB).getCollection(LOADER_ENTITY_DETAILS_COLL);
		BasicDBObject findQuery = new BasicDBObject("EntityType", "Workflow");
		if(entityName!=null && !entityName.contentEquals("")){
			findQuery.append("EntityName", entityName);
		}
		DBCursor cur = coll.find(findQuery);
		List<Map> toReturn = new ArrayList();
		while(cur.hasNext()){
			toReturn.add(cur.next().toMap());
		}
		return JSON.serialize(toReturn);
	}
	
	@Path("/getJobGroupDetails")
	@GET
	@Produces("text/JSON")
	public String getJobGroupDetails(@QueryParam("EntityName")String entityName) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(JOBS_DB).getCollection(LOADER_ENTITY_DETAILS_COLL);
		BasicDBObject findQuery = new BasicDBObject("EntityType", "JobGroup");
		if(entityName!=null && !entityName.contentEquals("")){
			findQuery.append("EntityName", entityName);
		}
		DBCursor cur = coll.find(findQuery);
		List<Map> toReturn = new ArrayList();
		while(cur.hasNext()){
			toReturn.add(cur.next().toMap());
		}
		return JSON.serialize(toReturn);
	}
	
	@Path("/getJobDetails")
	@GET
	@Produces("text/JSON")
	public String getJobDetails(@QueryParam("EntityName")String entityName) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(JOBS_DB).getCollection(LOADER_ENTITY_DETAILS_COLL);
		BasicDBObject findQuery = new BasicDBObject("EntityType", "Job");
		if(entityName!=null && !entityName.contentEquals("")){
			findQuery.append("EntityName", entityName);
		}
		DBCursor cur = coll.find(findQuery);
		List<Map> toReturn = new ArrayList();
		while(cur.hasNext()){
			toReturn.add(cur.next().toMap());
		}
		return JSON.serialize(toReturn);
	}
	
	@Path("/getTaskDetails")
	@GET
	@Produces("text/JSON")
	public String getTaskDetails(@QueryParam("EntityName")String entityName) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(JOBS_DB).getCollection(LOADER_ENTITY_DETAILS_COLL);
		BasicDBObject findQuery = new BasicDBObject("EntityType", "Task");
		if(entityName!=null && !entityName.contentEquals("")){
			findQuery.append("EntityName", entityName);
		}
		DBCursor cur = coll.find(findQuery);
		List<Map> toReturn = new ArrayList();
		while(cur.hasNext()){
			toReturn.add(cur.next().toMap());
		}
		return JSON.serialize(toReturn);
	}
	
	@Path("/getSubTypeMappingDetails")
	@GET
	@Produces("text/JSON")
	public String getSubTypeMappingDetails(@QueryParam("EntityName")String entityName, @QueryParam("Workflow")String workflow) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(CLIENT_DB).getCollection(LOADER_ENTITY_MAPPING_COLL);
		BasicDBObject findQuery = new BasicDBObject();
		if(entityName!=null && !entityName.contentEquals("") && workflow!=null && !workflow.contentEquals("")){
			findQuery.append("EntityName", entityName);
			findQuery.append("Workflow", workflow);
		}
		DBCursor cur = coll.find(findQuery);
		List<Map> toReturn = new ArrayList();
		if(cur.hasNext()){
			List<Map> subTypesList = (List<Map>)cur.next().toMap().get("SubTypesList");
			Collections.sort(subTypesList, sortOnSequence);
			for(Map subTypeMap : subTypesList){
				subTypeMap.put("Workflow", workflow);
				DBCursor cur2 = coll.find(new BasicDBObject("EntityName", subTypeMap.get("EntityName")).append("Workflow", workflow));
				if(cur2.hasNext()){
					Map subTypeMapping = cur2.next().toMap();
					List<Map> listOfsubTypeMappingChildren = (List<Map>)subTypeMapping.get("SubTypesList");
					Collections.sort(listOfsubTypeMappingChildren, sortOnSequence);
					subTypeMapping.put("SubTypesList", listOfsubTypeMappingChildren);
					subTypeMap.putAll(subTypeMapping);
				}
			}
			toReturn = subTypesList;
		}
		return JSON.serialize(toReturn);
	}
	
	@Path("/getMaxEntityId")
	@GET
	@Produces("text/JSON")
	public String getMaxEntityId() throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(JOBS_DB).getCollection(LOADER_ENTITY_DETAILS_COLL);
		BasicDBObject sortQuery = new BasicDBObject("EntityId",-1);
		
		DBCursor cur = coll.find().sort(sortQuery).limit(1);
		Integer maxEntityId = null;
		if(cur.hasNext()){
			maxEntityId = (Integer)cur.next().toMap().get("EntityId");
		}
		return String.valueOf(maxEntityId);
	}
	
//	@Path("/persistDetails")
//	@GET
//	@Produces("text/JSON")
//	public String persistDetails(@QueryParam("JSON")String json) throws UnknownHostException{
//		DBCollection coll = MongoConnection.getInstance().getDB("jobs_db").getCollection("loader_entity_details_coll");
//		
//		coll.insert(new BasicDBObject((Map)JSON.parse(json)), WriteConcern.ACKNOWLEDGED);
//		
//		return "Success";
//	}
	
	@Path("/persistMappings")
	@POST
	@Produces("text/JSON")
	public String persistMappings(@FormParam("Workflow")String workflow, @FormParam("JSON")String json) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(CLIENT_DB).getCollection(LOADER_ENTITY_MAPPING_COLL);
		System.out.println("Workflow : "+workflow+" JSON : "+json);
		BasicDBObject findQuery = new BasicDBObject("Workflow",workflow);
		BasicDBObject updateQuery = new BasicDBObject("$set", new BasicDBObject("IsLog",true));
		coll.update(findQuery, updateQuery, false, true, WriteConcern.ACKNOWLEDGED);
		
		List<Map> jsonList = (List<Map>)JSON.parse(json);
		List<DBObject> toInsert = new ArrayList();
		for(Map jsonMap : jsonList){
			toInsert.add(new BasicDBObject(jsonMap));
		}
		
		coll.insert(toInsert, WriteConcern.ACKNOWLEDGED);
		
		coll.remove(findQuery.append("IsLog", true));
		return "Success";
	}
	
	@Path("/persistDetails")
	@GET
	@Produces("text/JSON")
	public String persistDetails(@QueryParam("EntityId")String entityIdStr, @QueryParam("JSON")String json) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(JOBS_DB).getCollection(LOADER_ENTITY_DETAILS_COLL);
		Integer entityId = Integer.parseInt(entityIdStr);
		System.out.println("EntityId : "+entityId+" JSON : "+json);
		BasicDBObject findQuery = new BasicDBObject("EntityId",entityId);
//		BasicDBObject findQuery = new BasicDBObject("EntityId","");
		BasicDBObject updateQuery = new BasicDBObject("$set", new BasicDBObject("IsLog",true).append("EntityId", ""));
		coll.update(findQuery, updateQuery, false, true, WriteConcern.ACKNOWLEDGED);
		
		Map jsonMap = (Map)JSON.parse(json);
		BasicDBObject toInsert = new BasicDBObject(jsonMap);
		coll.insert(toInsert, WriteConcern.ACKNOWLEDGED);
		
		coll.remove(new BasicDBObject("IsLog", true));
		return "Success";
	}
	
	@Path("/getWorkflowMapping")
	@GET
	@Produces("text/JSON")
	public String getWorkflowMapping(@QueryParam("Workflow")String workflow) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(CLIENT_DB).getCollection(LOADER_ENTITY_MAPPING_COLL);
		BasicDBObject findQuery = new BasicDBObject("Workflow",workflow);
		
		List<Map> mappings = new ArrayList();
		DBCursor cur = coll.find(findQuery);
		while(cur.hasNext()){
			Map mapping = cur.next().toMap();
			List<Map> subMapping = (List<Map>)mapping.get("SubTypesList");
			Collections.sort(subMapping, sortOnSequence);
			mapping.put("SubTypesList", subMapping);
			mappings.add(mapping);
		}
		return JSON.serialize(mappings);
	}
	
	@Path("/removeMapping")
	@GET
	@Produces("text/JSON")
	public String removeMapping(@QueryParam("Workflow")String workflow) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(CLIENT_DB).getCollection(LOADER_ENTITY_MAPPING_COLL);
		BasicDBObject findQuery = new BasicDBObject("Workflow",workflow);
		BasicDBObject updateQuery = new BasicDBObject("$set", new BasicDBObject("IsLog",false));
		coll.update(findQuery, updateQuery, false, true, WriteConcern.ACKNOWLEDGED);
		return "success";
	}
	
	private Comparator<Map> sortOnSequence = new Comparator<Map>() {

		@Override
		public int compare(Map map1, Map map2) {
			int sequence1 = (int)map1.get("Sequence");
			int sequence2 = (int)map2.get("Sequence");
			if(sequence1>sequence2){
				return 1;
			}
			else if(sequence1<sequence2){
				return -1;
			}
			return 0;
		}
	};
	
	@Path("/getEntityConfigMapping")
	@GET
	@Produces("text/JSON")
	public String getTaskConfigMapping(@QueryParam("EntityName")String entityName,@QueryParam("Workflow")String workflow,@QueryParam("Job")String job) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(CLIENT_DB).getCollection(TASK_CONFIG);
//		BasicDBObject findQuery = new BasicDBObject("EntityType", "Task");
		BasicDBObject findQuery = new BasicDBObject();
		if(entityName!=null && !entityName.contentEquals("")){
//			findQuery.append("EntityName", entityName);
			findQuery.append("TaskName", entityName);
		}
		if(workflow!=null && !workflow.contentEquals("")){
//			findQuery.append("Workflow", workflow);
			findQuery.append("WorkflowName", workflow);
		}
//		if(jobGroup!=null && !jobGroup.contentEquals("")){
////			findQuery.append("Workflow", workflow);
//			findQuery.append("JobGroup", jobGroup);
//		}
		if(job!=null && !job.contentEquals("")){
//			findQuery.append("Workflow", workflow);
			findQuery.append("Job", job);
		}
		DBCursor cur = coll.find(findQuery);
		List<Map> toReturn = new ArrayList();
		while(cur.hasNext()){
			toReturn.add(cur.next().toMap());
		}
		return JSON.serialize(toReturn);
	}
	
	@Path("/getData")
	@GET
	@Produces("text/JSON")
	public String getData(@QueryParam("DBName")String dbName,@QueryParam("CollName")String collName,@QueryParam("Filter")String filter) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(dbName).getCollection(collName);
		BasicDBObject findQuery = new BasicDBObject((Map)JSON.parse(filter));
		DBCursor cur = coll.find(findQuery);
		List<Map> toReturn = new ArrayList();
		while(cur.hasNext()){
			Map data = cur.next().toMap();
			data.remove("_id");
			toReturn.add(data);
		}
		return JSON.serialize(toReturn);
	}
	
	@Path("/getWorkflowTasks")
	@GET
	@Produces("text/JSON")
	public String getWorkflowTasks(@QueryParam("Workflow")String workflow) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB(CLIENT_DB).getCollection(LOADER_ENTITY_MAPPING_COLL);
		BasicDBObject findQuery = new BasicDBObject("EntityType", "Job");
		findQuery.append("Workflow", workflow);
		DBCursor cur = coll.find(findQuery);
		List<Map> toReturn = new ArrayList();
		while(cur.hasNext()){
			Map jobMap = cur.next().toMap();
			List<Map> tasks = (List<Map>)jobMap.get("SubTypesList");
			Collections.sort(tasks, sortOnSequence);
			for(Map task : tasks){
				task.put("Job", jobMap.get("EntityName"));
				task.put("Workflow", workflow);
			}
			toReturn.addAll(tasks);
		}
		return JSON.serialize(toReturn);
	}
	
	@Path("/persistConfig")
	@POST
	@Produces("text/JSON")
	public String persistConfig(
			@FormParam("DBName")String dbName,
			@FormParam("CollName")String collName,
			@FormParam("Filter")String filter,
			@FormParam("Workflow")String workflow, 
			@FormParam("JSON")String json) throws UnknownHostException{
		
		DBCollection coll = MongoConnection.getInstance().getDB(dbName).getCollection(collName);
		System.out.println("Workflow : "+workflow+" JSON : "+json);
		BasicDBObject findQuery = new BasicDBObject((Map)JSON.parse(filter));
		BasicDBObject updateQuery = new BasicDBObject("$set", new BasicDBObject("IsLog",true));
		coll.update(findQuery, updateQuery, false, true, WriteConcern.ACKNOWLEDGED);
		
		List<Map> jsonList = (List<Map>)JSON.parse(json);
		List<DBObject> toInsert = new ArrayList();
		for(Map jsonMap : jsonList){
			toInsert.add(new BasicDBObject(jsonMap));
		}
		
		coll.insert(toInsert, WriteConcern.ACKNOWLEDGED);
		
		coll.remove(findQuery.append("IsLog", true));
		return "Success";
	}
	
	@Path("/persistTaskConfigMapping")
	@GET
	@Produces("text/JSON")
	public String persistTaskConfigMapping(@QueryParam("ConfigId")String configIdStr, @QueryParam("JSON")String json) throws UnknownHostException{
		DBCollection coll = MongoConnection.getInstance().getDB("jobs_db").getCollection("entity_config_mapping");
		Integer configId = Integer.parseInt(configIdStr);
		System.out.println("ConfigId : "+configId+" JSON : "+json);
		BasicDBObject findQuery = new BasicDBObject("ConfigId",configId);
		BasicDBObject updateQuery = new BasicDBObject("$set", new BasicDBObject("IsLog",true));
		coll.update(findQuery, updateQuery, false, true, WriteConcern.ACKNOWLEDGED);
		
		Map jsonMap = (Map)JSON.parse(json);
		BasicDBObject toInsert = new BasicDBObject(jsonMap);
		coll.insert(toInsert, WriteConcern.ACKNOWLEDGED);
		
		coll.remove(findQuery.append("IsLog", true));
		return "Success";
	}
}

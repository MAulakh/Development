package com.stratus.manager.mongoconnection;

import java.net.UnknownHostException;

import com.mongodb.Mongo;

public class MongoConnection {
	
	private MongoConnection(){}
	
	private static Mongo mongoConn = null;
	
	private static MongoConnection connection = new MongoConnection();
	
	public static Mongo getInstance() throws UnknownHostException{
		if(mongoConn==null){
			mongoConn = new Mongo("54.76.125.226");
//			mongoConn = new Mongo("172.31.50.206");
//			mongoConn = new Mongo("TT-Stratus-D02", 10001);
		}
		
		return mongoConn;
	}
}

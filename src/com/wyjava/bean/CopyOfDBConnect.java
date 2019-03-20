package com.wyjava.bean;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
/**
 * 数据库操作
 * @author WeiYuan
 *
 */
public class CopyOfDBConnect {
	public String url="jdbc:postgresql://127.0.0.1:5432/WYGIS";
	public String user="postgres";
	public String password = "123456";
	Statement statement=null;
	Connection connection=null;
	ResultSet resultSearch=null;
	/**
	 * 测试java函数
	 */
	public static void main(String []args)
	{
		CopyOfDBConnect c= new CopyOfDBConnect();
       //String result=c.getName("jing");
		String result= c.getFeatures("jing");
        System.out.println(result);
        System.out.println("finish");
    }
	/**
	 * 数据库连接
	 */
	public Connection link()
	{		 
		 try{
		     Class.forName("org.postgresql.Driver");
		    connection= DriverManager.getConnection(url, user, password);
		     System.out.println("已连接成功"+connection);
		     return connection;		            
		      }catch(Exception e){
		        throw new RuntimeException(e);
		     }
	}
	/**
	 * 获取指定名称的对象
	 * @param s_name 对象名称
	 * @return geojson对象
	 */
	public String getName(String s_name){
		//Statement statement =null;
		Connection con=link();
		 try{
		 String sql="select name, ST_AsGeoJson(geom) as pos from res2_4m WHERE res2_4m.name like "+"'%"+s_name+"%'";
		String up=s_name.toUpperCase();
		 String sql1="select name, ST_AsGeoJson(geom) as pos from res2_4m WHERE upper(pinyin) like "+"'%"+up+"%'";
		
		 System.out.println(sql);
		statement=con.createStatement();	
		resultSearch=statement.executeQuery(sql);
		//ResultSetMetaData metaData = resultSearch.getMetaData();  
		//int columnCount = metaData.getColumnCount();
		JSONArray array_1=new JSONArray();
		 while (resultSearch.next()) {
		    	JSONObject jsonObj = new JSONObject();
		    	String name =resultSearch.getString("name");
		    	JSONObject latlog=JSONObject.fromObject(resultSearch.getString("pos"));
                jsonObj.put("type", "Feature");
		        jsonObj.put("geometry", latlog);
		        JSONObject property=new JSONObject();
		        property.put("name",name);
		        jsonObj.put("properties", property);
		        array_1.add(jsonObj);
		    } 
		 resultSearch=statement.executeQuery(sql1);
			//ResultSetMetaData metaData = resultSearch.getMetaData();  
			//int columnCount = metaData.getColumnCount();
		 while (resultSearch.next()) {
		    	JSONObject jsonObj = new JSONObject();
		    	String name =resultSearch.getString("name");
		    	JSONObject latlog=JSONObject.fromObject(resultSearch.getString("pos"));
                jsonObj.put("type", "Feature");
		        jsonObj.put("geometry", latlog);
		        JSONObject property=new JSONObject();
		        property.put("name",name);
		        jsonObj.put("properties", property);
		        array_1.add(jsonObj);
		    } 
		 JSONObject obj=new JSONObject();
		 obj.put("type", "FeatureCollection");
		 obj.put("features", array_1);
	    //System.out.println(array_1.toString());
		 JSONObject result=JSONObject.fromObject(obj);
		// System.out.println(obj.toString());
         return result.toString();      
		}catch(Exception e){
	         throw new RuntimeException(e);
	        }finally{
	            try{
	            	resultSearch.close();
	                statement.close();
	                closeCon(con);
	            }
	            catch(SQLException e){
	                e.printStackTrace();
	                throw new RuntimeException(e);
	            	}
	        	}
	}
	
	public void init()
	{		 
		 try{
		     Class.forName("org.postgresql.Driver");
		     connection= DriverManager.getConnection(url, user, password);
		     System.out.println("已连接成功"+connection);	            
		      }catch(Exception e){
		        throw new RuntimeException(e);
		     }
	}
	
	/**
	 * 关闭连接	
	 */
public void closeCon(Connection con){
		try{
          		con.close();
          		System.out.println("数据库连接关闭");
		}catch(SQLException e){
            e.printStackTrace();
            throw new RuntimeException(e);
        }
	}
/**
 * 获取geojson数据
 * @param sql 条件
 */
public String getFeatures(String sname){
	Connection con=link();
	 try{
	 String sql="select name,pinyin,pid ST_AsGeoJson(geom) as pos from res2_4m WHERE res2_4m.name like "+"'%"+sname+"%'";
	String up=sname.toUpperCase();
	 String sql1="select name,pinyin,pid ST_AsGeoJson(geom) as pos from res2_4m WHERE upper(pinyin) like "+"'%"+up+"%'";
	
	 System.out.println(sql);
	statement=con.createStatement();	
	resultSearch=statement.executeQuery(sql);
	JSONArray array_1=new JSONArray();
	 while (resultSearch.next()) {
	    	JSONObject jsonObj = new JSONObject();
	    	String name =resultSearch.getString("name");
	    	String pinyin =resultSearch.getString("pinyin");
	    	JSONObject latlog=JSONObject.fromObject(resultSearch.getString("pos"));
            jsonObj.put("type", "Feature");
	        jsonObj.put("geometry", latlog);
	        JSONObject property=new JSONObject();
	        property.put("name",name);
	        property.put("pinyin", pinyin);
	        jsonObj.put("properties", property);
	        array_1.add(jsonObj);
	    } 
	 resultSearch=statement.executeQuery(sql1);
		//ResultSetMetaData metaData = resultSearch.getMetaData();  
		//int columnCount = metaData.getColumnCount();
	 while (resultSearch.next()) {
	    	JSONObject jsonObj = new JSONObject();
	    	String name =resultSearch.getString("name");
	    	String pid =resultSearch.getString("pid");
	    	String pinyin =resultSearch.getString("pinyin");
	    	JSONObject latlog=JSONObject.fromObject(resultSearch.getString("pos"));
           jsonObj.put("type", "Feature");
	        jsonObj.put("geometry", latlog);
	        JSONObject property=new JSONObject();
	        property.put("name",name);
	        property.put("pinyin", pinyin);
	        property.put("pid", pid);
	        jsonObj.put("properties", property);
	        array_1.add(jsonObj);
	    } 
	 JSONObject obj=new JSONObject();
	 obj.put("type", "FeatureCollection");
	 obj.put("features", array_1);
   
	 JSONObject result=JSONObject.fromObject(obj);
	// System.out.println(obj.toString());
    return result.toString();      
	}catch(Exception e){
        throw new RuntimeException(e);
       }finally{
           try{
           	resultSearch.close();
               statement.close();
               closeCon(con);
           }
           catch(SQLException e){
               e.printStackTrace();
               throw new RuntimeException(e);
           	}
       	}
}
	public String resultSetToJson(ResultSet rs) throws SQLException  
	{  
	   // json数组  
	   JSONArray array = new JSONArray();  
	    
	   // 获取列数  
	   ResultSetMetaData metaData = rs.getMetaData();  
	   int columnCount = metaData.getColumnCount();  
	    
	   // 遍历ResultSet中的每条数据  
	    while (rs.next()) {  
	        JSONObject jsonObj = new JSONObject();  
	         
	        // 遍历每一列  
	        for (int i = 1; i <= columnCount; i++) {  
	            String columnName =metaData.getColumnLabel(i);  
	            String value = rs.getString(columnName);  
	            jsonObj.put(columnName, value);  
	        }   
	        array.add(jsonObj);   
	    }  
	    
	   return array.toString();  
	}  
	public void updateData()
	{
		Connection con=link();
		String sql="UPDATE public.res2_4m SET name =?,pinyin= ? WHERE res2_4m.gid=?";
		try{
			PreparedStatement  ps=con.prepareStatement(sql);
			ps.close();
		}catch(SQLException e){
			
            closeCon(con);
			 e.printStackTrace();
             throw new RuntimeException(e);
		}
	}
}



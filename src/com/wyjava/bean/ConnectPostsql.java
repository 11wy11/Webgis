package com.wyjava.bean;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
/**
 * 数据库操作
 * @author WeiYuan
 *
 */
public class ConnectPostsql {
	public String url="jdbc:postgresql://172.17.38.243:5432/WYGIS";
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
       ConnectPostsql c= new ConnectPostsql();
       c.init();
       String result=c.getGeojson();
      System.out.println(result);
      System.out.println("finish");
    }
	/**
	 * 数据库连接
	 */
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
	 * 查询记录
	 * @param sql 条件
	 */
	public String search(String sql){
		//Statement statement =null;
		
		 try{
		 String result="";
		statement=connection.createStatement();	
		resultSearch=statement.executeQuery(sql);
        while(resultSearch.next()){
        	
        	//int columnNum=resultSearch.getMetaData().getColumnCount();
        	//for(int i=1;i<=columnNum;i++)//遍历所有的列      		
        	String geojson=resultSearch.getString("pos");
        	String name=resultSearch.getString("name");
        	//String latlog=resultSearch.getString(2);        	
        	geojson=geojson.replace("}",","+"\""+name+"\""+"}"+"," );
        	result=result+geojson;
            //System.out.println(result);
            //System.out.println(latlog);
        	}
        result=result.substring(0, result.length()-1);
        return result;
		}catch(Exception e){
	         throw new RuntimeException(e);
	        }finally{
	            try{
	            	resultSearch.close();
	                statement.close();
	                //resultSearch.close()
	                if(resultSearch==null)
	                System.out.println("查询结果为空");
	                closeCon();
	            }
	            catch(SQLException e){
	                e.printStackTrace();
	                throw new RuntimeException(e);
	            	}
	        	}
	}
	/**
	 * 关闭连接	
	 */
public void closeCon(){
		try{
          		connection.close();
		}catch(SQLException e){
            e.printStackTrace();
            throw new RuntimeException(e);
        }
	}

/**
 * 获取数据库中所有点的坐标和名称
 * @return geojson格式的字符串
 */
public String getGeojson(){
	 try{
	String result="";
	String geojson="";
	//pos是地理坐标的别名
	String sql="select name,ST_AsGeoJson(geom) as pos from Public.res2_4m";
	statement=connection.createStatement();	
	resultSearch=statement.executeQuery(sql);
	int i=0;
	while(resultSearch.next()){
	i++;
	String head="{\"type\": \"Feature\",\"id\":\"res2_4m."+i+"\", \"geometry\":";
   	String latlog=resultSearch.getString("pos");
   	String name=resultSearch.getString("name");
   	geojson=head+latlog+",\"properties\":{\"name\":\""+name+"\"}}," ;
   	result+=geojson;
   	}
   result=result.substring(0, result.length()-1);
   String head1= "{ \"type\":\"FeatureCollection\",\"totalFeatures\":331,\"features\": [";
	String foot="],\"crs\":{\"type\":\"name\",\"properties\":{\"name\":\"urn:ogc:def:crs:EPSG::4326\"}}}";
	result=head1+result+foot;
   return result;
	}catch(Exception e){
        throw new RuntimeException(e);
       }finally{
           try{
        	   resultSearch.close();
               statement.close();
               //resultSearch.close()
               if(resultSearch==null)
               System.out.println("查询结果为空");
               closeCon();
           }
           catch(SQLException e){
               e.printStackTrace();
               throw new RuntimeException(e);
           	}
       	}
}
public String example(){
	 
    return "{\"type\": \"Feature\",\"id\":\"res2_4m.1\", \"geometry\":{\"type\":\"Point\",\"coordinates\":[117.117942810059,29.1951675415039]},\"properties\":{\"name\":\"景德镇\"}}"; 
}
/**
 * 获取空间坐标geojson数据
 */
public String getLatlog(){
	 try{
	String result="";
	String sql="select name,ST_AsGeoJson(geom) as pos from Public.res2_4m";
	statement=connection.createStatement();	
	resultSearch=statement.executeQuery(sql);
	while(resultSearch.next()){	
  	String latlog=resultSearch.getString("pos");
  	result=result+latlog+",";
  	}
  result=result.substring(0, result.length()-1);
  return result;
	}catch(Exception e){
       throw new RuntimeException(e);
      }finally{
          try{
       	   resultSearch.close();
              statement.close();
              //resultSearch.close()
              if(resultSearch==null)
              System.out.println("查询结果为空");
              closeCon();
          }
          catch(SQLException e){
              e.printStackTrace();
              throw new RuntimeException(e);
          	}
      	}
}
}

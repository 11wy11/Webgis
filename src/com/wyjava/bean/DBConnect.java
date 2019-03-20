package com.wyjava.bean;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
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
 * 
 * @author WeiYuan
 * 
 */
public class DBConnect {
	
	public String url = "jdbc:postgresql://172.17.38.243:5432/WYGIS";
	public String user = "postgres";
	public String password = "123456";
	Statement statement=null;
	Connection connection=null;
	ResultSet resultSearch=null;

	/**
	 * 测试java函数
	 */
	public static void main(String[] args) {
		DBConnect c = new DBConnect();  
	    //String res=c.selectData("select adclass,count(*)as y from res2_4m group by adclass");
	    //System.out.println(res);
	    String res1=c.getZone("select count(*)as y,adcode93/100000 as province from res2_4m group by province");
	    System.out.println(res1);
	}

	/**
	 * 获取数据库连接
	 */
	public Connection link() {
		try {
			Class.forName("org.postgresql.Driver");
			connection = DriverManager.getConnection(url, user, password);
			System.out.println("已连接成功" + connection);
			return connection;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	/**
	 * 初始化数据连接
	 */
	public void init() {
		try {
			Class.forName("org.postgresql.Driver");
			connection = DriverManager.getConnection(url, user, password);
			System.out.println("已连接成功" + connection);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	/**
	 * 根据名称模糊查询features
	 * 既可以是汉字也可以拼音
	 * @param s_name对象名称
	 * @return name和geojson对象字符串
	 */
	public String getName(String s_name) {
		
		Connection con = link();
		try {
			String sql = "select name, ST_AsGeoJson(geom) as pos from res2_4m WHERE res2_4m.name like "
					+ "'%" + s_name + "%'";
			String up = s_name.toUpperCase();
			String sql1 = "select name, ST_AsGeoJson(geom) as pos from res2_4m WHERE upper(pinyin) like "
					+ "'%" + up + "%'";

			System.out.println(sql);
			statement = con.createStatement();
			resultSearch = statement.executeQuery(sql);
			JSONArray array_1 = new JSONArray();
			while (resultSearch.next()) {
				JSONObject jsonObj = new JSONObject();
				String name = resultSearch.getString("name");
				JSONObject latlog = JSONObject.fromObject(resultSearch
						.getString("pos"));
				jsonObj.put("type", "Feature");
				jsonObj.put("geometry", latlog);
				JSONObject property = new JSONObject();
				property.put("name", name);
				jsonObj.put("properties", property);
				array_1.add(jsonObj);
			}
			resultSearch = statement.executeQuery(sql1);
			while (resultSearch.next()) {
				JSONObject jsonObj = new JSONObject();
				String name = resultSearch.getString("name");
				JSONObject latlog = JSONObject.fromObject(resultSearch
						.getString("pos"));
				jsonObj.put("type", "Feature");
				jsonObj.put("geometry", latlog);
				JSONObject property = new JSONObject();
				property.put("name", name);
				jsonObj.put("properties", property);
				array_1.add(jsonObj);
			}
			JSONObject obj = new JSONObject();
			obj.put("type", "FeatureCollection");
			obj.put("features", array_1);
			JSONObject result = JSONObject.fromObject(obj);
			return result.toString();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			try {
				resultSearch.close();
				statement.close();
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
				throw new RuntimeException(e);
			}
		}
	}

	/**
	 * 关闭连接
	 */
	public void closeCon(Connection con) {
		try {
			
			con.close();
			System.out.println("数据库连接关闭");
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}

	/**
	 * 根据名称获取全部属性信息
	 * @param sname城市名称
	 * @return json格式的字符串
	 */
	public String getFeatures(String sname) {
		
		Connection con = link();
		try {
			String sql = "select name,pinyin,gid,updator,updatetime,ST_AsGeoJson(geom) as pos from res2_4m WHERE res2_4m.name like "
					+ "'%" + sname + "%'";
			String up = sname.toUpperCase();
			String sql1 = "select name,pinyin,gid,updator,updatetime,ST_AsGeoJson(geom) as pos from res2_4m WHERE upper(pinyin) like "
					+ "'%" + up + "%'";

			System.out.println(sql);
			statement = con.createStatement();
			resultSearch = statement.executeQuery(sql);
			JSONArray array_1 = new JSONArray();
			while (resultSearch.next()) {
				JSONObject jsonObj = new JSONObject();
				String name = resultSearch.getString("name");
				String pinyin = resultSearch.getString("pinyin");
				String gid = resultSearch.getString("gid");
				String updator = resultSearch.getString("updator");
				String updatetime = resultSearch.getString("updatetime");
				JSONObject latlog = JSONObject.fromObject(resultSearch
						.getString("pos"));
				jsonObj.put("type", "Feature");
				jsonObj.put("geometry", latlog);
				JSONObject property = new JSONObject();
				property.put("name", name);
				property.put("pinyin", pinyin);
				property.put("gid", gid);
				property.put("updator", updator);
				property.put("updatetime", updatetime);
				jsonObj.put("properties", property);
				array_1.add(jsonObj);
			}
			resultSearch = statement.executeQuery(sql1);
			while (resultSearch.next()) {
				JSONObject jsonObj = new JSONObject();
				String name = resultSearch.getString("name");
				String pinyin = resultSearch.getString("pinyin");
				String gid = resultSearch.getString("gid");
				String updator = resultSearch.getString("updator");
				String updatetime = resultSearch.getString("updatetime");
				JSONObject latlog = JSONObject.fromObject(resultSearch
						.getString("pos"));
				jsonObj.put("type", "Feature");
				jsonObj.put("geometry", latlog);
				JSONObject property = new JSONObject();
				property.put("name", name);
				property.put("pinyin", pinyin);
				property.put("gid", gid);
				property.put("updator", updator);
				property.put("updatetime", updatetime);
				jsonObj.put("properties", property);
				array_1.add(jsonObj);
			}
			JSONObject obj = new JSONObject();
			obj.put("type", "FeatureCollection");
			obj.put("features", array_1);

			JSONObject result = JSONObject.fromObject(obj);	 
			System.out.println(result.toString());
			return result.toString();
			
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			try {
				resultSearch.close();
				statement.close();
				closeCon(con);
			} catch (SQLException e) {
				e.printStackTrace();
				throw new RuntimeException(e);
			}
		}
	}
	/**
	 * 将结果数据集转为json字符串
	 * @param rs
	 * @return
	 * @throws SQLException
	 */
	public String resultSetToJson(ResultSet rs) throws SQLException {
		
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
				String columnName = metaData.getColumnLabel(i);
				String value = rs.getString(columnName);
				jsonObj.put(columnName, value);
			}
			array.add(jsonObj);
		}

		return array.toString();
	}
	
	 /** 
     * 根据文件路径上传图片 
     *  
     * @param path 
     * @param name 
     */  
    public void uploadImage(String path, String name) {  
     
       String sql = "update res2_4m  set picture=? WHERE pinyin like'"+name.substring(0, name.length()-4)+"'";  
       try {
    	   Connection conn=link();
    	   PreparedStatement ps =null; 
    	   ps = conn.prepareStatement(sql);  
  
            // 设置图片名称  
            ps.setString(1, name);  
  
            // 设置图片文件  
            File file = new File(path );  
            FileInputStream inputStream = new FileInputStream(file);  
            ps.setBinaryStream(1, inputStream, (int) file.length());  
  
            // 执行SQL  
            ps.execute();  
            ps.close();  
            conn.close();
            System.out.println(path +" 已上传");  
  
        } catch (SQLException e) {  
            System.err.println("SQL " + sql + " 错误");  
        } catch (FileNotFoundException e) {  
            System.err.println("图片 " + path + "\\" + name + " 没有找到");  
        }  
    }  
  /**
   * 通过文件输入流存入图片
   * @param id
   * @param stream
   */
    public static void UpdateImage(String name,InputStream stream)
	{
		Connection connection=null;
	     try{
	    	 DBConnect db=new DBConnect();
	         connection= db.link();
	         String sql="update res2_4m set picture=? where name like'"+name+"'";
	         PreparedStatement statement=connection.prepareStatement(sql);
	         System.out.println("数据库操作：更新"+name+stream);
	         statement.setBinaryStream(1,stream);
	         statement.executeUpdate();
	         statement.close();
	         stream.close();
	     }
	     catch (Exception e){
	            throw new RuntimeException(e);}
	     finally{
             try{
                 connection.close();
             }
             catch(SQLException e){
                 e.printStackTrace();
                 throw new RuntimeException(e);
             }
         }
	     
	}
    
    /** 
     * 从数据库下载图片 
     *  
     * @param path 
     */  
    public void downloadImage(String path) {  
  
        String sql = "SELECT picture_name,picture FROM res2_4m";  
        Connection conn=link();
        PreparedStatement ps =null;
        String name = "";  
        try {  
            ps = conn.prepareStatement(sql);  
            ResultSet rs = ps.executeQuery();  
  
            while (rs.next()) {  
  
                name = rs.getString(1);  
                InputStream inputStream = rs.getBinaryStream(2);  
                FileOutputStream outputStream = new FileOutputStream(new File(  
                        path + "\\_" + name));  
  
                int i = inputStream.read();  
                while (i != -1) {  
                    outputStream.write(i);  
                    i = inputStream.read();  
                }  
                outputStream.close();  
  
                System.out.println(path + "\\_" + name + " 已下载");  
            }  
  
            rs.close();  
            ps.close(); 
            conn.close();
  
        } catch (SQLException e) {  
            System.err.println("SQL " + sql + " 错误");  
        } catch (FileNotFoundException e) {  
            System.err.println(path + "\\_" + name + " 创建失败");  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
    }  
    /**
     * 根据城市名称查pinyin
     * @param str
     * @return
     */
	public String getpinyin(String name)
	{
		try
		{
			String result="";
			
			
			String sql="select pinyin from res2_4m where name="+"'"+name+"'";
			
			statement=connection.createStatement();
			
	            ResultSet resultSet=statement.executeQuery(sql);
	            while(resultSet.next()){
	                
	                result=resultSet.getString(1);
	                
	              
	            }
	           
	            return result;
		}
		catch(Exception e){
            throw new RuntimeException(e);
        }
		
	}
	/**
	 * 获得更新者名称
	 * @param name城市名称
	 * @return 
	 */
	public String getupdater(String name)
	{
		try
		{
			String result="";
			
			
			String sql="select updater from res2_4m where name="+"'"+name+"'";
			
			statement=connection.createStatement();
			
	            ResultSet resultSet=statement.executeQuery(sql);
	            while(resultSet.next()){
	                
	                result=resultSet.getString(1);
	                
	              
	            }
	           
	            return result;
		}
		catch(Exception e){
            throw new RuntimeException(e);
        }
		
	}
	/**
	 * 获取城市id
	 * @param str
	 * @return
	 */
	public String getID(String name)
	{
		try
		{
			String result="";			
			String sql="select gid from res2_4m where name="+"'"+name+"'";			
			statement=connection.createStatement();			
	            ResultSet resultSet=statement.executeQuery(sql);
	            while(resultSet.next()){	                
	                result=resultSet.getString(1);         
	            }	           
	            return result;
		}
		catch(Exception e){
            throw new RuntimeException(e);
        }
	}
	/**
	 * 获得更新时间
	 * @param name
	 * @return
	 */
	public String getupdatetime(String name)
	{
		try
		{
			String result="";				
			String sql="select updatetime from res2_4m where name="+"'"+name+"'";			
			statement=connection.createStatement();		
	            ResultSet resultSet=statement.executeQuery(sql);
	            while(resultSet.next()){	                
	                result=resultSet.getString(1);	              	              
	            }	           
	            return result;
		}
		catch(Exception e){
            throw new RuntimeException(e);
        }
	}
	/**
	 * 获得照片输入流
	 * @param id
	 * @return
	 */
	public byte[] getPicbyte(String id)
	{
		byte[] buf=null;
		try{
			 String sql="select picture from res2_4m where gid="+id;
			 PreparedStatement pstmt=connection.prepareStatement(sql);
			
			 ResultSet rs=pstmt.executeQuery();
			 rs.next();
		    buf=rs.getBytes("picture");
			 pstmt.close();
			 connection.close();
			
            } 
	catch (Exception ex) {
			   ex.printStackTrace();
		}
		 return buf;
    }
	/**
	 * 更新数据库属性信息
	 * @param name
	 * @param pinyin
	 * @param id
	 * @param updater
	 * @param time
	 */
	public void update(String name,String pinyin, String id, String updator, String time)
	{
		try
		{
		String sql="UPDATE public.res2_4m SET name ='"+name+"',pinyin='"+pinyin+"',updator='"+updator+"',updatetime='"+time+"' where gid="+id;
		System.out.println(sql);	
			statement=connection.createStatement();
			
	           statement.executeUpdate(sql);
	            
	     }
		catch(Exception e){
            throw new RuntimeException(e);
        }finally{
            try{
                statement.close();
            }
            catch(SQLException e){
                e.printStackTrace();
                throw new RuntimeException(e);
            }finally{
                try{
                    connection.close();
                }
                catch(SQLException e){
                    e.printStackTrace();
                    throw new RuntimeException(e);
                }
            }
        }
	}
	public void insertData(String name,String pinyin, String coordinate, String updator, String time){
		try
		{
			coordinate=coordinate.replace(",", " ");
			System.out.println(coordinate);
		//String sql="INSERT res2_4m(name,pinyin,geom,updator,updatetime)values('"+name+"','"+pinyin+"',st_geomfromtext("+coordinate+"),'"+updator+"','"+time+"'" +")";
			String sql="INSERT INTO public.\"res2_4m\"(name,pinyin,geom,updator,updatetime)values('"+name+"','"+pinyin+"','"+coordinate+"','"+updator+"','"+time+"'" +")";
			System.out.println(sql);	
			statement=connection.createStatement();
			
	           statement.executeUpdate(sql);	            
	     }
		catch(Exception e){
            throw new RuntimeException(e);
        }finally{
            try{
                statement.close();
            }
            catch(SQLException e){
                e.printStackTrace();
                throw new RuntimeException(e);
            }finally{
                try{
                    connection.close();
                }
                catch(SQLException e){
                    e.printStackTrace();
                    throw new RuntimeException(e);
                }
            }
        }
	
	}
	/**
	 * 根据查询语句返回结果
	 * @param sql
	 * @return
	 */
public String selectData(String sql) {
		
		Connection con = link();
		try {
			System.out.println("统计的查询语句"+sql);
			statement = con.createStatement();
			resultSearch = statement.executeQuery(sql);
			JSONArray array = new JSONArray();
			ResultSetMetaData metaData = resultSearch.getMetaData();  
			 int columnCount = metaData.getColumnCount();  
			while (resultSearch.next()) {
				JSONObject jsonObj = new JSONObject();
				 for (int i = 1; i <= columnCount; i++) {  
			            String columnName =metaData.getColumnLabel(i);  
			            String value = resultSearch.getString(columnName);  
			            jsonObj.put(columnName, value);  
			        }   
			       array.add(jsonObj);
			}
			JSONObject obj = new JSONObject();
			obj.put("features", array);
			JSONObject result = JSONObject.fromObject(obj);	 
			System.out.println(result.toString());
			return result.toString();
			
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			try {
				resultSearch.close();
				statement.close();
				closeCon(con);
			} catch (SQLException e) {
				e.printStackTrace();
				throw new RuntimeException(e);
			}
		}
	}
    /**二进制流转为8进制
     * @param args 
     */  
public String getZone(String sql){
	Connection con = link();
	try {
		System.out.println("统计的查询语句"+sql);
		statement = con.createStatement();
		resultSearch = statement.executeQuery(sql);
		JSONArray array = new JSONArray(); 
		while (resultSearch.next()) {
		JSONObject jsonObj = new JSONObject(); 
		if(resultSearch.getString("province")==null)
			continue;
		 String name=resultSearch.getString("province");
		 //System.out.println(name);
		 String y=resultSearch.getString("y");
		 //System.out.println(name);
		 jsonObj.put("name",name);
		   jsonObj.put("y",y);
		 
		  array.add(jsonObj);      
		}
		JSONObject obj = new JSONObject();
		obj.put("features", array);
		JSONObject result = JSONObject.fromObject(obj);	 
		System.out.println(result.toString());
		return result.toString();
		
	} catch (Exception e) {
		throw new RuntimeException(e);
	} finally {
		try {
			resultSearch.close();
			statement.close();
			closeCon(con);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}
}
    public static String binarys(byte[] bytes){
        StringBuffer sbf = new StringBuffer("");
        for (int i = 0; i < bytes.length; i++) {
            String tmp = Integer.toOctalString(bytes[i] & 0xff);
            switch (tmp.length()) {
            case 1:
                tmp = "\\00" +tmp;
                break;
            case 2:
                tmp = "\\0" +tmp;
                break;
            case 3:
                tmp = "\\" +tmp;
                break;
            default:
                break;
            }
            sbf.append(tmp);
        }
        
        return sbf.toString();
    }
}

<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%> 
<%@ page import ="com.wyjava.bean.DBConnect" 
        import="java.sql.Connection"
		import="java.sql.DriverManager"
		import="java.sql.ResultSet"
		import="java.sql.ResultSetMetaData"
		import="java.sql.SQLException"
		import= "java.sql.Statement"
		import ="net.sf.json.JSONArray"
		import= "net.sf.json.JSONException"
		import= "net.sf.json.JSONObject"
%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
	String []words=new String[1];
	DBConnect d=new DBConnect();
	Connection con=d.link();
	Statement statement=null;
	ResultSet resultSearch=null;
	 try{
	 //查询出所有的名称
	 String sql="select name,pinyin from res2_4m";
	 statement=con.createStatement();	
	 resultSearch=statement.executeQuery(sql);
	 while (resultSearch.next()) {
	    	JSONObject jsonObj = new JSONObject();
	    	String name =resultSearch.getString("name");
	    	String pinyin =resultSearch.getString("pinyin");    	
	        words=Arrays.copyOf(words, words.length+1);
    		words[words.length-1]=name;//向字符串中添加值
    		words=Arrays.copyOf(words, words.length+1);
    		words[words.length-1]=pinyin;//向字符串中添加值
	    }
	  System.out.println(words.length); 
	  }catch(Exception e){
         throw new RuntimeException(e);
        }finally{
            try{
            	resultSearch.close();
                statement.close();
                d.closeCon(con);
            }
            catch(SQLException e){
                e.printStackTrace();
                throw new RuntimeException(e);
            	}
        	}
%>
<%
	if(request.getParameter("search-text") != null) { 
		String key = request.getParameter("search-text"); 
		if(key.length() != 0){ 
		 String json="["; 
		for(int i = 0; i < words.length; i++) { 
		if(words[i].startsWith(key)){ 
		json += "\""+ words[i] + "\"" + ","; 
		} 
		} 
		json = json.substring(0,json.length()-1>0?json.length()-1:1); 
		json += "]"; 
		System.out.println("json:" + json); 
		out.println(json); 
		} 
  }
       else
       {out.print("");
       }
%>
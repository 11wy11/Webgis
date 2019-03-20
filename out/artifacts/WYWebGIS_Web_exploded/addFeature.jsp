<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@page import="com.wyjava.bean.User" import="java.io.IOException"
	import="java.io.PrintWriter" import="java.net.URLDecoder"
	import="com.wyjava.bean.DBConnect" import="net.sf.json.JSONArray"
	import="net.sf.json.JSONObject" import="java.sql.Connection"
	import="java.sql.DriverManager" import="java.sql.ResultSet"
	import="java.sql.ResultSetMetaData" import="java.sql.SQLException"
	import="java.sql.Statement" import="java.sql.PreparedStatement"
	import="java.sql.Timestamp"
	import="org.apache.commons.fileupload.FileItem"
	import="org.apache.commons.fileupload.FileUploadException"
	import="org.apache.commons.fileupload.disk.DiskFileItemFactory"
	import="org.apache.commons.fileupload.servlet.ServletFileUpload"
	import="java.io.InputStream"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'addFeature.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
    <%
	Timestamp currentTime= new Timestamp(System.currentTimeMillis());
	System.out.println("更新数据");
		response.setContentType("text/html;charset=UTF-8");
		DiskFileItemFactory factory = new DiskFileItemFactory();	
		ServletFileUpload upload=new ServletFileUpload(factory);
		String time=currentTime.toString();
		System.out.println("更新时间"+time);	
		if(session==null){
		 out.println("用户未登录,请登陆后再操作");
		 return;
		}
		User u =(User)session.getAttribute("user");
		String updater=u.getUsername();
		updater=URLDecoder.decode(updater,"UTF-8");
		System.out.println("更新人员为："+updater);
		String cityname="";
		String pinyin="";
		String cooridnate="";
		try{
				List<FileItem> list=upload.parseRequest(request);
				InputStream stream;
				System.out.println("文件流项："+list.size());
				if(list.size()>0){
				 for (FileItem item: list) 
				{ 
	                String name = item.getFieldName();
					if (item.isFormField()) {
				         if(name.equals("name")) 
				         {    cityname=item.getString();       	
		                	  cityname=new String(cityname.getBytes("ISO8859-1"),"UTF-8");
		                		 System.out.println(cityname);
		                	 }
		                if(name.equals("pinyin")) 
				         {    pinyin=item.getString();       	
		                		 System.out.println(pinyin);
		                	 }
		               if(name.equals("cooridnate")) 
				         {    cooridnate=item.getString();     
		                		 System.out.println(cooridnate);
		                	 }                                   
		                   											
					}
					if(!item.isFormField()){
						stream=item.getInputStream();				
						System.out.println(stream);
						
						}
					} 
				}
				DBConnect d=new DBConnect();
				d.init();
		        d.insertData(cityname, pinyin, cooridnate, updater, time);
		        //DBConnect.UpdateImage(cityname,stream);
		        //stream.close();
		}catch (FileUploadException e) {					
			e.printStackTrace();
			}	
	%>
	添加成功
  </body>
</html>

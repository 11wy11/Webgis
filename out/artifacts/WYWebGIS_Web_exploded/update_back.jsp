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

<title>My JSP 'update.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="stylesheet" href="css/table.css">
<script type="text/javascript" src="js/alttable.js"></script>
</head>

<body>
	<%
	Timestamp currentTime= new Timestamp(System.currentTimeMillis());
    //储存查询回的名称、拼音和id
    	List<String> aname= new ArrayList<String>();
    	List<String> apinyin = new ArrayList<String>();
    	List<String> agid = new ArrayList<String>();
    	System.out.println("更新数据");
		response.setContentType("text/html;charset=UTF-8");
		DiskFileItemFactory factory = new DiskFileItemFactory();	
		ServletFileUpload upload=new ServletFileUpload(factory);
		String time=currentTime.toString();
		System.out.println("更新时间"+time);	
		User u =(User)session.getAttribute("user");
		String updater=u.getUsername();
		updater=URLDecoder.decode(updater,"UTF-8");
		System.out.println("更新人员为："+updater);
		int num=0;
		String cityname="";
		String pinyin="";
		String gid="";
		try{
				List<FileItem> list=upload.parseRequest(request);
				InputStream stream;
				System.out.println("文件流项："+list.size());
				if(list.size()>0){
				for (FileItem item: list) 
				{ 		String name = item.getFieldName();
						System.out.println(name);
	                  if(name.equals("count")){
	                     String number=item.getString();
	                     num= Integer.parseInt(number);
	                     System.out.println("共更新"+num+"条城市记录");
	                  }
	            }            
	          	for(int i=0;i<num;i++){
	          	//遍历每组记录,更新属性信息
	          	  for (FileItem item: list) 
				{ 
	                String name = item.getFieldName();
					if (item.isFormField()) {
				         if(name.equals("name"+i)) 
				         {    cityname=item.getString();       	
		                	  cityname=new String(cityname.getBytes("ISO8859-1"),"UTF-8");
		                		 System.out.println(cityname);
		                	 }
		                 if(name.equals("gid"+i)) 
				         {    gid=item.getString();       	
		                	  gid=new String(gid.getBytes("ISO8859-1"),"UTF-8");
		                		 System.out.println(gid);
		                	 }
		                if(name.equals("pinyin"+i)) 
				         {    pinyin=item.getString();       	
		                	  pinyin=new String(pinyin.getBytes("ISO8859-1"),"UTF-8");
		                		 System.out.println(pinyin);
		                	 }                                    
		                   											
					} 
				}	
					DBConnect d=new DBConnect();
					d.init();
		            d.update(cityname, pinyin, gid, updater, time);
		               
				}
				String picname="";
	               
				for(int i=0;i<num;i++){
				//更新图片
					String filePath="";
				for (FileItem item: list) 
				{ 
	                String name = item.getFieldName();
	               
	                if(name.equals("name"+i)) 
				    {   picname=item.getString();       	
		               	picname=new String(picname.getBytes("ISO8859-1"),"UTF-8");
		               	System.out.println(picname);
		          	}
		          	 if(name.equals("filePath"+i)) 
				    {   filePath=item.getString();
				    	System.out.println(filePath);
				    	if(num!=1&&filePath.equals("0"))
				    	break;   
		          	}
					if(!item.isFormField()){
						stream=item.getInputStream();
						if(num==1){				
						System.out.println(stream);
						DBConnect.UpdateImage(picname,stream);
						}
						}
					}
				}
			}//end if (list.size())
			//stream.close();
		}catch (FileUploadException e) {					
			e.printStackTrace();
			}
     %>
	修改成功。
</body>
</html>

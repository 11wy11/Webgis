<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@page import="java.io.IOException" import="java.io.PrintWriter"
	import="java.net.URLDecoder" import="com.wyjava.bean.DBConnect"
	import="net.sf.json.JSONArray" import="net.sf.json.JSONObject"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>Show query</title>

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
   		System.out.println("showpage");
    	List<String> aname= new ArrayList<String>();
    	List<String> apinyin = new ArrayList<String>(); 
    	List<String> agid = new ArrayList<String>();
    	List<String> aupdator = new ArrayList<String>();
	    List<String> aupdatetime = new ArrayList<String>(); 
    	String cityname=request.getParameter("name");
		cityname =URLDecoder.decode(cityname, "UTF-8");
		cityname =URLDecoder.decode(cityname, "UTF-8");
		System.out.println(cityname);
		DBConnect db=new DBConnect();
		JSONObject geojson=JSONObject.fromObject(db.getFeatures(cityname));
		System.out.println(geojson);
		JSONArray array =JSONArray.fromObject(geojson.get("features"));
			for(int i=0;i<array.size();i++)
			{
				JSONObject proper=JSONObject.fromObject(array.getJSONObject(i).get("properties"));
				String sname =proper.getString("name");
				String spinyin=proper.getString("pinyin");
				String sgid=proper.getString("gid");
				String supdator=proper.getString("updator");
				String supdatetime=proper.getString("updatetime");
				aname.add(i,sname);
				apinyin.add(i, spinyin); 
				agid.add(i,sgid);
				aupdator.add(i,supdator);
				aupdatetime.add(i,supdatetime);
			}
     %>
	<div id="hid" style="display:none"><%=geojson%></div>
	<div id="information" class="information">
	<form>
		<table class="altrowstable" id="alternatecolor">
			
			<%
		for(int i=0;i<aname.size();i++)
		  {
		 %>
			 <tr>
				<th>城市名称</th>
			</tr>
			<tr>
				<td><%=aname.get(i) %></td>
				<td><%=apinyin.get(i) %></td>
			</tr>
			<tr>
				<th>更新信息</th>
			</tr>
			<tr>
			     <td>更新人员：<%=aupdator.get(i) %></td>
			   
			      <td>更新时间<%=aupdatetime.get(i) %></td>
			 </tr>
			 <tr>
					<td>城市名片：</td>
				</tr>
				<tr>
					<td height="150px"><img height="150px" width="150px"
						src="servlet/GetPicture?id=<%=agid.get(i)%>+&Math.random()" /></td>
				</tr>    
			
				<%} %>
			
		</table>

	</form>
	</div>


</body>
</html>

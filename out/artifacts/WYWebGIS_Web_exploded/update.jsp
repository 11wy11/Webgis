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

<title>My JSP 'update.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="stylesheet" href="css/table.css">
<linik rel="stylesheet" href="css/main.css">
<script type="text/javascript" src="js/alttable.js"></script>
<script type="text/javascript" src="js/searchbyjsp.js"></script>
</head>

<body>
	<script type="text/javascript"
		src="http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js"></script>
	<script src="http://libs.baidu.com/jquery/2.0.0/jquery.js"></script>
	<%
		System.out.println("update page");
	       //储存查询回的名称、拼音和id
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
	<div class="information">
		<form id="queryform" action="update_back.jsp" method="POST"
			enctype="multipart/form-data" name="queryform" target="update_iframe">
			<table class="altrowstable" id="alternatecolor">
				<tr>
					<th>城市详情</th>

				</tr>
				<%
					int i;
						for( i=0;i<aname.size();i++)
						  {
				%>
				<tr>
					<td><input class="change_input" name="name<%=i%>" type="text"
						value="<%=aname.get(i)%>">
					</td>
					<td><input class="change_input" name="pinyin<%=i%>"
						type="text" value="<%=apinyin.get(i)%>">
					</td>
					<td><input class="change_input" name="gid<%=i%>" type="text"
						value="<%=agid.get(i)%>" style="display:none">
					</td>
				</tr>
				<tr>
					<td width="30px" height="30px">更新人员：</td>
					<td><input class="change_input" name="updator<%=i%>"
						type="text" value="<%=aupdator.get(i)%>">
					</td>
				</tr>
				<tr>

					<td width="30px" height="30px">更新时间：</td>
					<td><input class="change_input" name="updatetime<%=i%>"
						type="text" value="<%=aupdatetime.get(i)%>">
					</td>
				</tr>
				<tr>
					<td>城市名片：</td>
				</tr>
				<tr>
					<td height="150px"><img height="150px" width="150px"
						src="servlet/GetPicture?id=<%=agid.get(i)%>+&Math.random()" /></td>
				</tr>
				<tr>
					<td colspan="2" align="center" height="30px">
					<input  style="display:none" name="filePath<%=i%>" value="0" id="filePath<%=i%>"/>
					<input
						type="file" name="img<%=i%>" class="file" id="img<%=i%>" onchange="setValue()" />
					</td>
				</tr>
				<%
					}
				%>

			</table>
			<input type="text" name="count" value=<%=i%> style="display:none" />	
			<input type="submit" id="update_submit" name="update_submit"
				value="提交修改信息" onclick="updateFinish()"/> <input type="button"
				id="update_cancel" name="update_cancel" value="取消" />
		</form>
	</div>
	<script>
	function setValue(){
	    var fileObject=document.getElementById("filePath<%=i%>");
	    fileObject.value=1;
		alert(fileObject.value);
	}
	
	function updateFinish(){
	$.ajax({ 
	    type : "POST", 
	   data :  $('#queryform').serialize(),
	    url : "update_back.jsp", 
	    contentType: "multipart/form-data; charset=UTF-8", 
	    success : function(result) {
	    	searchName_ajax();
	 },
	    error:function(XMLHttpRequest, textStatus, errorThrown) {
			 alert(textStatus);
	    }   
	   }); 
	   }
	</script>
	
</body>
</html>

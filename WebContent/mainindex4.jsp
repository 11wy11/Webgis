<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.wyjava.bean.testBean"%>
<%@ page import="com.wyjava.bean.ConnectPostsql"%>
<%@ page import="com.wyjava.bean.DBConnect"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<%
	ConnectPostsql c = new ConnectPostsql();
	c.init();
	String str = c.getGeojson();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv=Content-Type content="text/html;charset=utf-8">
<meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
<meta content=always name=referrer>
<title>WY Page base on openlayers3</title>
<link rel="stylesheet"
	href="https://openlayers.org/en/v4.2.0/css/ol.css" type="text/css">
<link rel="stylesheet" href="css/main.css">
<link rel="stylesheet" href="css/map.css">
<link rel="stylesheet" href="css/overview.css">
<link rel="stylesheet" href="css/control.css">
<link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">

<script>
	var map, vectorLayer, geoLayer,vectorLayer1;//地图、全部矢量点、geoserverWMS、查询的点
	var select; //创建一个交互选择对象  
	var modify; //设置要素为交互选择对象所获取的要素     
	var styleFunction;
	var styles;
	var isAdmin = 0;
</script>
</head>

<body>
	<!-- <h2>Hello,welcome to my page </h2> -->
	<!--用户登录 -->
	<form id="formLogin" name="formLogin" action="userLogin.shtml" method="post">  
    <h1>用户登录</h1>  
    <div>  
        <input type="text" placeholder="用户名" required="" id="username" name="account"/>  
    </div>  
    <div>  
        <input type="password" placeholder="密码" required="" id="password" name="passwd"/>  
    </div>  
    <div class="">  
        <span class="help-block u-errormessage" id="js-server-helpinfo"> </span>  
    </div>              
    <div>  
        <!-- <input type="submit" value="Log in" /> -->  
        <input type="submit" value="登录" class="btn btn-primary" id="js-btn-login" style="float: left;"/>        
        <input type="button" value="重置" class="btn btn-primary" id="js-btn-login" style="float: right;" onclick="doReset();"/>  
    </div>  
	</form>

	<script>
	$(document).ready(function() {  
       $("#formLogin").ajaxForm(function(data){  
             alert("post success." + data);  
             //Alert("post success.");  
       });            
	});
</script>
	<button id="administrator" onclick="validate()">管理员登录</button>
	<button id="custom" onclick="validate1()">用户登录</button>
	<div class="container-fluid">
		<div class="row" id="webbody">
			<div class="col-md-2" id="maplist">
				<!--左侧地图菜单-->
				<div class="panel-group" id="accordion">
					<!--地图目录-->
					<div class="panel panel-default">
						<div class="panel-heading" id="panel-title-total">
							<h4 class="panel-title">功能</h4>
						</div>
					</div>
					<div class="panel-body ">

						<ul>
							<li><a href="images/buffer.png">缓冲区分析</a></li>
							<li><a href="images/Info.png">属性查询</a></li>
							<li><a href="images/options.png">选择目标</a></li>
							<li><a href="images/Rect.png">矩形选框</a></li>
							<li><a href="images/select.png">选择目标</a></li>
							<li><a href="images/stastistics.png">统计分析</a></li>
						</ul>
						<div class="panel panel-default">
							<div class="panel-heading" id="panel-title-total">
								<h4 class="panel-title">查询</h4>
							</div>
						</div>
						<form id="searchForm">
							<p>城市名称 ：</p>
							<input id="cityname" class="search_input one legant-aero"
								type="text" placeholder="请输入你要查询的城市""> <input
								type="button" name="button_city" value="查询" id="button_city"
								class="button blue" onclick="serchName_ajax()"> <input
								type="button" name="cancel" value="取消" id="cancel_city"
								class="button blue" onclick="cancel()">
						</form>
						<form enctype="multipart/form-data" action="servlet/UploadFile"
							method=post id="upload">
							<p>城市名称 ：</p>
							<input type="text" name="picturename">
							<p>上传图片：</p>
							<input type="file" name="img"
								accept="image/png,image/gif,image/jpeg"> <input
								type="submit" name="submit_file" value="上传" id="submit_file"
								class="button blue"> <input type="button"
								name="cancel_file" value="取消" id="cancel_file"
								class="button blue" onclick="cancel()">

								<%-- <table>
						<tr><td>选择照片</td><td><input type="file" name="image"accept="image/png,image/gif,image/jpeg"></td></tr>
						<tr><td>城市名称</td><td><input type="text" name="picture.name"/></td></tr>
						<tr><td colspan="2"><input type="hidden" name="picture.uid" value="<s:property value="user.ID"/>">
						<input type="submit" value="提交照片"></td></tr>
						</table> --%>
						</form>
					</div>

				</div>
			</div>
			<div class="col-md-10" id="mapbody">
				<div id="map" class="map"></div>
				<div id="popup" class="ol-popup">
					<a href="#" id="popup-closer" class="ol-popup-closer"></a>
					<div id="popup-content" style="width:240px; height:100px;"></div>
				</div>

			</div>
		</div>
		<div id="attr_table"></div>

		<iframe id="update_iframe" style="display:none" name="update_iframe"></iframe>
		<div id="resText"></div>
		
	</div>
	<script src="https://openlayers.org/en/v4.2.0/build/ol.js"></script>
	<script src="http://libs.baidu.com/jquery/2.0.0/jquery.js"></script>
	<script>
		var image = new ol.style.Circle({
			radius : 5,
			fill : new ol.style.Fill({
				color : 'rgba(255, 228, 196, 0.8)'
			}),
			stroke : new ol.style.Stroke({
				color : 'rgba(255,165,0,1)',
				width : 1
			})
		});

		var style = new ol.style.Style({
			image : image
		});
		var image1 = new ol.style.Circle({
			radius : 5,
			fill : new ol.style.Fill({
				color : 'rgba(0, 255, 255, 0.8)'
			}),
			stroke : new ol.style.Stroke({
				color : 'rgba(0, 255, 255,1)',
				width : 1
			})
		});

		var style_hightlight = new ol.style.Style({
			image : image1
		});

		var myGeoJSON =
	<%=str%>
		;
		var vectorSource = new ol.source.Vector({
			features : (new ol.format.GeoJSON()).readFeatures(myGeoJSON, ({
				dataProjection : "EPSG::4326",
				featureProjection : "EPSG::3857"
			}))
		});
		vectorLayer = new ol.layer.Vector({
			source : vectorSource,
			style : style
		});
		var geographic = new ol.proj.Projection("EPSG:4326");
		var mercator = new ol.proj.Projection("EPSG:900913");
		geoLayer = new ol.layer.Tile({
			//extent:[ol.proj.transform((73.44696044921875,3.408477306365967,135.08583068847656,53.557926177978516), geographic, mercator )],
			extent : [ 73.44696044921875, 3.408477306365967,
					135.08583068847656, 53.557926177978516 ],
			source : new ol.source.TileWMS({
				url : 'http://localhost:8088/geoserver/webgis/wms',
				params : {
					'LAYERS' : 'BoundaryChn2_4p',
					'TILED' : true
				},
				serverType : 'geoserver'
			})
		});
		var osm = new ol.layer.Tile({
			source : new ol.source.OSM()
		});

		//map.addControl(new ol.control.MousePosition());
		var overviewMapControl = new ol.control.OverviewMap({
			// see in overviewmap-custom.html to see the custom CSS used
			className : 'ol-overviewmap ol-custom-overviewmap',
			layers : [ osm, geoLayer ],
			collapseLabel : '\u00BB',
			label : '\u00AB',
			collapsed : false,
			view : new ol.View({
				center : [ 110, 36 ],
				projection : 'EPSG:4326',
				zoom : 5
			})
		});

		//创建一个交互选择对象  
		select = new ol.interaction.Select({
			//水平包裹  
			//Wrap the world horizontally on the selection overlay 
			style : style_hightlight,
			wrapX : false
		});

		//创建一个交互修改对象  
		modify = new ol.interaction.Modify({

			features : select.getFeatures()
		});
		map = new ol.Map(
				{

					//添加全图浏览控件
					controls : ol.control.defaults().extend(
							[ overviewMapControl ]),
					interactions : ol.interaction.defaults().extend(
							[ new ol.interaction.DragRotateAndZoom(),
									select, modify ]),
					// 设置地图图层
					layers : [
					// 创建一个使用Open Street Map地图源的瓦片图层
					osm, geoLayer 
					], // 设置显示地图的视图
					view : new ol.View({
						center : [ 110, 36 ],
						projection : 'EPSG:4326',
						zoom : 4
					}),
					// 让id为map的div作为地图的容器
					target : 'map'
				});
	</script>
	<script type="text/javascript" src="js/map.js"></script>
	<script type="text/javascript"
		src="http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js"></script>
	<!-- <script type="text/javascript" src="js/operator.js"></script> -->
	<script type="text/javascript" src="js/searchbyjsp.js"></script>
	<!-- <script type="text/javascript" src="js/alttable.js"></script> -->
	<script>
		function validate() {
			isAdmin = 2;
		}
		function validate1() {
			isAdmin = 1;
		}
	</script>
</body>
</html>


<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="com.wyjava.bean.testBean"%>
<%@ page import="com.wyjava.bean.ConnectPostsql"%>
<%@ page import="com.wyjava.bean.DBConnect"%>
<%@ page import="com.wyjava.bean.User"%>
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
<!--主页样式  -->
<link rel="stylesheet" href="css/main.css">
<!--地图样式  -->
<link rel="stylesheet" href="css/map.css">
<!-- 弹出窗样式 -->
<link rel="stylesheet" href="css/overview.css">

<link rel="stylesheet" href="css/control.css">
<link rel="stylesheet" href="css/ol3-layerswitcher.css">
 <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css">
<!-- <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css"> -->
<script>
	var map, vectorLayer, geoLayer,vectorLayer1;//地图、全部矢量点、geoserverWMS、查询的点
	var select; //创建一个交互选择对象  
	var modify; //设置要素为交互选择对象所获取的要素     
	var styleFunction;
	var styles;
	var isAdmin = 2;
	var measureActive=false;
	<%-- var username=<%User u=((User)session.getAttribute("user")); out.print(u.getUsername());%>;//登录用户
	if(username==""){isAdmin=1;}
	else{isAdmin=2;} --%>
</script>
</head>

<body>
	<!--用户登录 -->
	<div id="header">
		<form id="formLogin" name="formLogin" style="float:left">
			<input type="text" placeholder="用户名" id="username" name="username" />
			<input type="password" placeholder="密码" id="password" name="password" />
			验证码： <input type="text" placeholder="请输入验证码" id="authCode"
				name="authCode" style="width:191px;height:33px;"> <img
				src="servlet/GetAuthCode" border="0" alt="验证码,看不清楚?请点击刷新验证码"
				style="cursor:pointer;" onclick="changeImage(this)" />
			<!-- <input type="submit" value="Log in" /> -->
			<label> <input type="checkbox" name="remember_me"
				id="rembUser"> 记住密码 </label> <input type="button" value="登录"
				class="btn btn-primary" id="js-btn-login" onclick="login()" /> <input
				type="button" value="注册" class="btn btn-primary" id="js-btn-signUp"
				onclick="signUp()" /> <input type="reset" value="重置"
				class="btn btn-primary" id="js-btn-clear" "/>
		</form>
		
		当前登录用户：${user.username}
		<a href="servlet/LoginOutServlet">退出登录</a>
		<div>欢迎您，${user.username}<div id="username" style="display:none">${user.username}</div></div>
	</div>

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
						<button id="zoomtoPoint" >缩放至要素</button>
						<button id="measureControl" >量测工具</button>
						<form class="form-inline">
					      <label>Measurement type &nbsp;</label>
					        <select id="type">
					          <option value="length">Length (LineString)</option>
					          <option value="area">Area (Polygon)</option>
					        </select>
					        <label class="checkbox">
					          <input type="checkbox" id="geodesic">
					          use geodesic measures
					        </label>
					    </form>			 
						<ul>
							
							<li><a>统计分析</a></li>
						</ul>
						<div class="panel panel-default">
							<div class="panel-heading" id="panel-title-total">
								<h4 class="panel-title">查询</h4>
							</div>
						</div>
						<!--查询表单  -->
						<form id="searchForm">
							<p>城市名称 ：</p>
							<input id="cityname" class="search_input one legant-aero"
								type="text" placeholder="请输入你要查询的城市" " /> 
								<input type="button" name="button_city" value="查询" id="button_city"
								class="button blue" onclick="searchName_ajax()" /> 
								<input type="reset" name="cancel" value="取消" id="cancel_city"
								class="button blue"  />
						</form>
						<!--上传表单  -->
						<!-- <form enctype="multipart/form-data" id="upload">

							<p>城市名称 ：</p>
							<input id="picname" class="search_input one legant-aero"
								type="text" placeholder="请输入你要更新的城市"  /> 
							<p>上传图片：</p>
							<input type="file" name="img" id="img"
								accept="image/png,image/gif,image/jpeg" /> <input
								type="button" name="submit_file" value="上传" id="submit_file"
								class="button blue" onclick="sendImage()" /> 
								<input
								type="reset" name="cancel_file" value="取消" id="cancel_file"
								class="button blue" />
						</form> -->

					</div>

				</div>
			</div>
			<div class="col-md-10" id="mapbody">
				<div id="map" class="map"></div>
				<div id="popup" class="ol-popup">
					<a href="#" id="popup-closer" class="ol-popup-closer"></a>
					<div id="popup-content" style="width:240px; height:100px;"></div>

				</div>
				<div id="scale-line" class="scale-line"></div>
				<div class="x-zoom-icons">
        <span id="zoom_in" class="glyphicon glyphicon-zoom-in"></span>
        <span id="zoom_out" class="glyphicon glyphicon-zoom-out"></span>
      </div>

			</div>
		</div>

		<div id="attr_table"></div>
		<iframe id="update_iframe" style="display:none" name="update_iframe"></iframe>
		<div id="resText"></div>

	</div>



	<script src="js/validate.js"></script>
	<script src="https://openlayers.org/en/v4.2.0/build/ol.js"></script>
	<script type="text/javascript"
		src="http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js"></script>
	<script src="http://libs.baidu.com/jquery/2.0.0/jquery.js"></script>
	
	<!--地图显示  -->
	<script>
	function sendImage(){
	alert("sendImage");
		var xhr1;
		 var picname =$("#picname").val();
		 if(picname=""){
		    alert("请输入城市名称");
		    return;
		   	}
		   	alert(picname);
		//cityname=encodeURI(cityname);
		  
		var form = new FormData(); // FormData 对象
		
		var queryString ="servlet/UploadFile?name="+picname;
		//创建xmlhttprequest
		if (window.ActiveXObject)
			xhr1 = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest)
			xhr1 = new XMLHttpRequest();
		if (document.getElementById("img").value != "")
		{
			var fileObj = document.getElementById("img").files[0]; // js 获取文件对象
			form.append("mf", fileObj); // 文件对象
		}
	xhr1.open("POST", queryString);
	xhr1.send(form);
	xhr1.onreadystatechange=function(e)
	{
	    if(xhr1.readyState==4&&xhr1.status==200)
	     {
	     alert("更新成功！");
	     /*  serchName_ajax(); */
	     }
	}
}	
	
	</script>
	<!-- <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script> -->
	<!--地图图层控制  -->
<script src="js/ol3-layerswitcher.js"></script>
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
		/* 矢量图层 */
		vectorLayer = new ol.layer.Vector({
			source : vectorSource,
			style : style,
			 title: 'Cities'
		});
		var thunderforestAttributions = [
        new ol.Attribution({
            html: 'Tiles &copy; <a href="http://www.thunderforest.com/">Thunderforest</a>'
        }),
        ol.source.OSM.ATTRIBUTION
    ];
    /*geoserver图层  */
		var geographic = new ol.proj.Projection("EPSG:4326");
		var mercator = new ol.proj.Projection("EPSG:900913");
		geoLayer = new ol.layer.Tile({
			//extent:[ol.proj.transform((73.44696044921875,3.408477306365967,135.08583068847656,53.557926177978516), geographic, mercator )],
			title: 'geoserverLy',
			extent : [ 73.44696044921875, 3.408477306365967,
					135.08583068847656, 53.557926177978516 ],
			source : new ol.source.TileWMS({
				url : 'http://172.17.38.243:8080/geoserver/WYWebGIS/wms',
				params : {
					'LAYERS' : 'BoundaryChn2_4p',
					'TILED' : true
				},
				serverType : 'geoserver'
			})
		});
		var osm = new ol.layer.Tile({
		 	title: 'OSM',
			source : new ol.source.OSM(),
			 type: 'base',
             visible: true
		});

		/* 鹰眼图 */
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
		/* 比例尺控件 */
		var scaleLineControl= new ol.control.ScaleLine({
           className: 'ol-scale-line', 
			target: document.getElementById('scale-line')     
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
		/*鼠标坐标 */
   		 var mousePositionControl= new ol.control.MousePosition({
         coordinateFormat: ol.coordinate.createStringXY(4),
        projection: 'EPSG:4326',
        className: 'custom-mouse-position',
        target: document.getElementById('mouse-position')
        });
       //拖拽文件显示到地图
		var dragAndDropInteraction = new ol.interaction.DragAndDrop({
		  formatConstructors: [
		    ol.format.GeoJSON,
		    ol.format.KML
		  ]
		});
	/* 		var snapControl=new ol.interaction.Snap({
	    pixelTolerance: 50,
	    source: VectorLayer
		}); */
      var zoomtoExtentControl=new ol.control.ZoomToExtent({
            extent: [
              73.44696044921875,3.408477306365967,135.08583068847656,53.557926177978516
            ]
          });
		map = new ol.Map(
				{

					//添加全图浏览控件
					controls : ol.control.defaults().extend(
							[ overviewMapControl,scaleLineControl,mousePositionControl,zoomtoExtentControl]),
					interactions : ol.interaction.defaults().extend(
							[ new ol.interaction.DragRotateAndZoom(),//地图旋转功能
							dragAndDropInteraction,//拖拽文件
									select, modify ]),
					// 设置地图图层
					layers:[
					 new ol.layer.Group({
                	'title': 'Base maps',
					layers : [
					// 创建一个使用Open Street Map地图源的瓦片图层
					osm ,geoLayer
					]}), 
					 new ol.layer.Group({
                title: 'Overlays',
                layers: [vectorLayer]})],
					// 设置显示地图的视图
					view : new ol.View({
						center : [ 110, 36 ],
						projection : 'EPSG:4326',
						zoom : 4
					}),
					// 让id为map的div作为地图的容器
					target : 'map'
				});
	map.addControl(new ol.control.LayerSwitcher());
		 /*拉框放大缩小*/
	//2017.7.1
	// dragzoom 构造函数
	 // 初始化一个拉框控件
	 var dragzoomInActive=false;
	 var dragzoomOutActive=false;
      var dragZoom = new ol.interaction.DragZoom({
        condition: ol.events.condition.always,
        out: false, // 此处为设置拉框完成时放大还是缩小
      });
      // 初始化一个拉框控件
      var dragZoom1 = new ol.interaction.DragZoom({
        condition: ol.events.condition.always,
        out: true, // 此处为设置拉框完成时放大还是缩小
      });
      map.addInteraction(dragZoom);
       map.addInteraction(dragZoom1);
      dragZoom.setActive(false);
      // 绑定放大缩小按钮事件
      document.querySelector("#zoom_in").addEventListener('click', function() {
        if (dragzoomInActive) {
          dragZoom.setActive(false);
          dragzoomInActive = false;
          document.querySelector("#map").style.cursor = "default";
        } else {
          dragZoom.G = false;
          dragZoom.setActive(true);
          dragzoomInActive = true;
          document.querySelector("#map").style.cursor = "crosshair";
        }
      }, false);
      document.querySelector("#zoom_out").addEventListener('click', function() {
        if (dragzoomOutActive) {
          dragZoom1.setActive(false);
          dragzoomOutActive = false;
          document.querySelector("#map").style.cursor = "default";
        } else {
          dragZoom1.G = true;
          dragZoom1.setActive(true);
          dragzoomOutActive = true;
          document.querySelector("#map").style.cursor = "crosshair";
        }
      }, false);
	</script>
	<!--地图交互  -->
	<script type="text/javascript" src="js/map.js"></script>
	
	<!-- <script type="text/javascript" src="js/operator.js"></script> -->
	<!--表单提交处理  -->
	<script type="text/javascript" src="js/searchbyjsp.js"></script>
	<!-- <script type="text/javascript" src="js/alttable.js"></script> -->
	<!--标记用户性质  -->
</body>
</html>


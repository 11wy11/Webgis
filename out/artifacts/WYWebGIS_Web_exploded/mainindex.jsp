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
<title>WY Page based on openlayers4.2</title>
<link rel="stylesheet"
	href="https://openlayers.org/en/v4.2.0/css/ol.css" type="text/css">
<!--主页样式  -->
<link rel="stylesheet" href="css/main.css">
<!--图层控制样式  -->
<link rel="stylesheet" href="css/ol3-layerswitcher.css">
<link rel="stylesheet"
	href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css">

</head>

<body>
	<input type='checkbox' id='sideToggle'>
	<aside>
	<h2>菜单栏</h2>
	<div class="menu">
		<div class="panel panel-default">
			<div class="panel-heading" id="panel-title-total">
				<h4 class="panel-title">工具</h4>
			</div>
		</div>
		<div class="panel-body ">
			<button class="button orange" id="zoomtoPoint">缩放至要素</button>
			<button class="button orange" id="measureControl" onclick="fun()">量测工具</button>
			<label>测距类型 &nbsp;</label> <select id="type">
				<option value="length">长度 (LineString)</option>
				<option value="area">面积 (Polygon)</option>
			</select> <label class="checkbox"> <input type="checkbox"
				id="geodesic"> 使用球面测距</label>

		</div>
		<div class="panel panel-default">
			<div class="panel-heading" id="panel-title-total">
				<h4 class="panel-title">统计</h4>
			</div>
		</div>
		<div class="panel-body ">
			<ul>

				<li><a class="degree">城市等级统计</a></li>
				<li><a class="subarea">城市各省统计</a></li>
				<li><a class="zone">城市分区统计</a></li>
				<li><a class="closechart">切换统计图</a></li>
			</ul>
			
		</div>
		<div class="panel panel-default">
			<div class="panel-heading" id="panel-title-total">
				<h4 class="panel-title">查询</h4>
			</div>
		</div>
		<div class="panel-body ">
			<!--查询表单  -->
			<form id="searchForm">
				<p>城市名称 ：</p>				
				<input id="cityname" class="search_input one legant-aero"
					type="text" placeholder="请输入你要查询的城市" " /> <input type="button"
					name="button_city" value="查询" id="button_city"
					class="button orange" onclick="searchName_ajax()" /> <input
					type="reset" name="cancel" value="取消" id="cancel_city"
					class="button orange" />
			</form>
			当前状态：
			<iframe id="update_iframe" name="update_iframe"></iframe>
		</div>
	</div>
	</aside>
	<div id='wrap'>
		<label id='sideMenuControl' for='sideToggle'>=</label>
		<!--用户登录 -->
		<div id="header">
			<form id="login_form" name="login_form" style="float:left">
				<input type="text" placeholder="用户名" id="username" name="username" />
				<input type="password" placeholder="密码" id="password"
					name="password" /> 验证码： <input type="text" placeholder="请输入验证码"
					id="authCode" name="authCode" style="width:191px;height:33px;">
				<img src="servlet/GetAuthCode" border="0" alt="验证码,看不清楚?请点击刷新验证码"
					style="cursor:pointer;" onclick="changeImage(this)" />
				<!-- <input type="submit" value="Log in" /> -->
				<label> <input type="checkbox" name="remember_me"
					id="rembUser"> 记住密码 </label> <input type="button" value="登录"
					class="btn btn-primary" id="js-btn-login" onclick="login()" /> <input
					type="button" value="注册" class="btn btn-primary" id="js-btn-signUp"
					onclick="signUp()" /> <input type="reset" value="重置"
					class="btn btn-primary" id="js-btn-clear" "/>
			</form>
			<div style="float:left">
			当前登录用户：${user.username} <div id= "loginout" style="float:right"><a  href="servlet/LoginOutServlet">退出登录</a></div>
			
				欢迎您，${user.username}
			</div>
		</div>
		<div class="col-md-10" id="mapbody">
			<div id="map" class="map"></div>
			<div id="info">&nbsp;</div>
			<div id="popup" class="ol-popup">
				<a href="#" id="popup-closer" class="ol-popup-closer"></a>
				<div id="popup-content" style="width:240px; height:100px;"></div>

			</div>
			<div id="scale-line" class="scale-line"></div>
			<div class="x-zoom-icons">
				<span id="zoom_in" class="glyphicon glyphicon-zoom-in"></span> <span
					id="zoom_out" class="glyphicon glyphicon-zoom-out"></span>
			</div>
			<div id="attr_table">
			
			</div>
			
			<div id="container" style="min-width:400px;height:400px;display:none"></div>
			<div id="container1" style="min-width:400px;height:400px;display:none"></div>
			<div id="container2" style="min-width:400px;height:400px;display:none"></div>
			<div id="resText"></div>
		<div class="footer">
		<p>Copyright©2017  weiyuan  .All Rights Reserved</p>
		<p>提供技术支持openlayers</p>
		</div>
		</div>
		
	</div>
	<!--定义全局变量  -->
<script>
	var map, vectorLayer, geoLayer,vectorLayer1;//地图、全部矢量点、geoserverWMS、查询的点
	var select; //创建一个交互选择对象  
	var modify; //设置要素为交互选择对象所获取的要素     
	var styleFunction;
	var styles;
	var isAdmin = 2;
	var measureActive=false;
</script>
	
	<script src="https://openlayers.org/en/v4.2.0/build/ol.js"></script>
	<script type="text/javascript"
		src="http://ajax.microsoft.com/ajax/jquery/jquery-1.4.min.js"></script>
	<script src="http://libs.baidu.com/jquery/2.0.0/jquery.js"></script>
	
	<!--地图图层控制  -->
	<script type="text/javascript" src="js/ol3-layerswitcher.js"></script>
	<!--测距  -->
	<script type="text/javascript">function fun(){window.location.href="measure.jsp";}</script>

	
	<!-- 查询统计模块 -->
	<script type="text/javascript" src="js/queryModule.js"></script>
	
	<!-- <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script> -->
	<!-- hightchart库 -->
	<script src="https://img.hcharts.cn/jquery/jquery-1.8.3.min.js"></script>
	<script src="https://img.hcharts.cn/highcharts/highcharts.js"></script>
	<script src="https://img.hcharts.cn/highcharts/modules/exporting.js"></script>	
	<script src="https://img.hcharts.cn/highcharts/modules/data.js"></script>	
	<script src="https://img.hcharts.cn/highcharts/modules/drilldown.js"></script>	
<!-- 	<script src="https://img.hcharts.cn/highcharts-plugins/hightcharts-zh_CN.js"></script> -->
	<script src="https://img.hcharts.cn/highcharts/themes/grid-light.js"></script>
	
	<script type="text/javascript" src="js/jquery.cookie.js"></script>
		<!-- 用户验证 -->
	<script type="text/javascript" src="js/validate.js"></script>
	<!--地图显示 -->
	<script type="text/javascript">
	$(document).ready(function(e) {
    $(".degree").click(function(e) {
       var sql="select adclass,count(*)as y from res2_4m group by adclass";
		dgreeChart(sql);
		$("#container").toggle();
		$("#container1").css("display","none");
		$("#container2").css("display","none");
     });
     $(".subarea").click(function(e) {
       var sql="select count(*)as y,adcode93/10000 as Province from res2_4m group by Province";
		subareaChart(sql);
		$("#container1").toggle();
		$("#container").css("display","none");
		$("#container2").css("display","none");
     });
     $(".zone").click(function(e) {
       var sql="select count(*)as y,adcode93/100000 as province from res2_4m group by province";
		zoneChart(sql);
		$("#container2").toggle();
		$("#container1").css("display","none");
		$("#container").css("display","none");
     });
     $(".closechart").click(function(e) {
     $("#container").toggle();
      $("#container1").toggle();
      $("#container2").toggle();
     });
     $("#attr_closer").click(function(e) {
      $("#attr_table").hide();
     });
     if ($.cookie("rmbUser") == "true") {
  $("#rmbUser").attr("checked", true);
  $("#username").val($.cookie("username"));
  $("#password").val($.cookie("password"));
  }
	 // a=getCookie("username"); 
	c_start=document.cookie.indexOf("username="); 
	if(c_start == -1){ 
	$("#login_form").show(); 
	} 
	else{ 
	$("#login_form").hide(); 
	$.cookie("rmbUser", "false", { expire: -1 });
    $.cookie("username", "", { expires: -1 });
    $.cookie("password", "", { expires: -1 });
	}
	
	$("loginout").click(function(e) {
 	 $("#login_form").show(); 
 	 $("#loginout").hide(); 
 	 $.cookie("rmbUser", "false", { expire: -1 });
    $.cookie("username", "", { expires: -1 });
    $.cookie("password", "", { expires: -1 });
  }); 
	});
	/* <!-- 地图显示 --> */

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
			layers : [ osm 
			//,geoLayer 
			],
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
        var defaultStyle = {
        'Point': new ol.style.Style({
          image: new ol.style.Circle({
            fill: new ol.style.Fill({
              color: 'rgba(255,255,0,0.5)'
            }),
            radius: 5,
            stroke: new ol.style.Stroke({
              color: '#ff0',
              width: 1
            })
          })
        }),
        'LineString': new ol.style.Style({
          stroke: new ol.style.Stroke({
            color: '#f00',
            width: 3
          })
        }),
        'Polygon': new ol.style.Style({
          fill: new ol.style.Fill({
            color: 'rgba(0,255,255,0.5)'
          }),
          stroke: new ol.style.Stroke({
            color: '#0ff',
            width: 1
          })
        }),
        'MultiPoint': new ol.style.Style({
          image: new ol.style.Circle({
            fill: new ol.style.Fill({
              color: 'rgba(255,0,255,0.5)'
            }),
            radius: 5,
            stroke: new ol.style.Stroke({
              color: '#f0f',
              width: 1
            })
          })
        }),
        'MultiLineString': new ol.style.Style({
          stroke: new ol.style.Stroke({
            color: '#0f0',
            width: 3
          })
        }),
        'MultiPolygon': new ol.style.Style({
          fill: new ol.style.Fill({
            color: 'rgba(0,0,255,0.5)'
          }),
          stroke: new ol.style.Stroke({
            color: '#00f',
            width: 1
          })
        })
      };

      var styleFunction = function(feature, resolution) {
        var featureStyleFunction = feature.getStyleFunction();
        if (featureStyleFunction) {
          return featureStyleFunction.call(feature, resolution);
        } else {
          return defaultStyle[feature.getGeometry().getType()];
        }
      };
       
       
       
		var dragAndDropInteraction = new ol.interaction.DragAndDrop({
		  formatConstructors: [
		    ol.format.GeoJSON,
		    ol.format.KML,ol.format.XML
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
					osm
					// ,geoLayer
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
		
	</script>
	<!--地图交互  -->
	<script type="text/javascript" src="js/operator.js"></script>
</body>
</html>


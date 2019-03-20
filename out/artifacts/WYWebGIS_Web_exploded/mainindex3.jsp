<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import ="com.wyjava.bean.testBean" %>
<%@ page import ="com.wyjava.bean.ConnectPostsql" %>
<%@ page import ="com.wyjava.bean.DBConnect" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%-- <%ConnectPostsql c=new ConnectPostsql();
   c.init();
String str= c.getGeojson();%> --%>
<%
ConnectPostsql c=new ConnectPostsql();
   c.init();
String str= c.getGeojson();
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<meta http-equiv=Content-Type content="text/html;charset=utf-8">
    <meta http-equiv=X-UA-Compatible content="IE=edge,chrome=1">
    <meta content=always name=referrer>
    <title>WY Page base on openlayers3</title>
     <link rel="stylesheet" href="https://openlayers.org/en/v4.2.0/css/ol.css" type="text/css">
<!--      <link rel="stylesheet" href="css/main.css">  --> 
      <link rel="stylesheet" href="css/map.css">  
      <link rel="stylesheet" href="css/overview.css">
     <!--  <link rel="stylesheet" href="css/toolbar.css">
      <link rel="stylesheet" href ="css/control.css"> -->
       <script src="http://libs.baidu.com/jquery/2.0.0/jquery.js"></script>
    <script>var map, vectorLayer,geoLayer; 
    		var select;		//创建一个交互选择对象  
    		var modify;  //设置要素为交互选择对象所获取的要素     
    </script>
  </head>
  
  <body>
   <h2>Hello,welcome to my page </h2>
   <div id="head"></div>
   <div id="body">
     <div id="left">
   		<div id="toolbar" class="toolbar">
   			<a href="images/buffer.png" class="toolbar-item toolbar-item-buffer"></a>
			<a href="images/Info.png" class="toolbar-item toolbar-item-info"></a>
			<a href="images/options.png" class="toolbar-item toolbar-item-options"></a>
			<a href="images/Rect.png" class="toolbar-item toolbar-item-rect"></a>
   			<a href="images/select.png" class="toolbar-item toolbar-item-select"></a>
   			<a href="images/stastistics.png" class="toolbar-item toolbar-item-stastistics"></a>
   		</div>
   	</div>
     	<div id="main">
		    <div id="map" class="map"></div>
		     <div id="popup" class="ol-popup">  
		    <a href="#" id="popup-closer" class="ol-popup-closer"></a>  
		    <div id="popup-content" style="width:240px; height:100px;"></div>  
			</div>
			 <div>  
       			 <label>修改几何图形：请用鼠标选择修改要素，选中后再修改其几何信息</label>  
   			 </div> 
		</div>
   </div>
   <div id="footer"></div>   
   
	 <script src="https://openlayers.org/en/v4.2.0/build/ol.js"></script>
    <script>
    var image = new ol.style.Circle({
        radius: 5,
        fill: new ol.style.Fill({color: 'rgba(255, 228, 196, 0.8)'}),
        stroke: new ol.style.Stroke({color: 'rgba(255,165,0,1)', width: 1})
      });

      var style = new ol.style.Style({
          image: image
        });
     var image1 = new ol.style.Circle({
        radius: 5,
        fill: new ol.style.Fill({color: 'rgba(0, 255, 255, 0.8)'}),
        stroke: new ol.style.Stroke({color: 'rgba(0, 255, 255,1)', width: 1})
      });

      var style_hightlight = new ol.style.Style({
          image: image
        });   
        
	      var myGeoJSON =<%=str%>;     
	      var vectorSource = new ol.source.Vector({
	        features: (new ol.format.GeoJSON()).readFeatures(myGeoJSON,
	        ({
	          dataProjection: "EPSG::4326",
	          featureProjection:"EPSG::3857"}))
	      });
	     vectorLayer = new ol.layer.Vector({
	        source: vectorSource,
	        style: style
	      });
	    var geographic = new ol.proj.Projection("EPSG:4326");
        var mercator = new ol.proj.Projection("EPSG:900913");
	    geoLayer= new ol.layer.Tile({
	    //extent:[ol.proj.transform((73.44696044921875,3.408477306365967,135.08583068847656,53.557926177978516), geographic, mercator )],
	    extent:[73.44696044921875,3.408477306365967,135.08583068847656,53.557926177978516],
	    source: new ol.source.TileWMS({
	    	url:'http://localhost:8088/geoserver/WebGIS/wms',
	    	params:{'LAYERS':'BoundaryChn2_4p','TILED':true},
	    	serverType:'geoserver'
	    })
	    });
	    var osm= new ol.layer.Tile({source: new ol.source.OSM()});
       
	    //map.addControl(new ol.control.MousePosition());
	   var overviewMapControl = new ol.control.OverviewMap({
        // see in overviewmap-custom.html to see the custom CSS used
        className: 'ol-overviewmap ol-custom-overviewmap',
        layers: [geoLayer
        ],
        collapseLabel: '\u00BB',
        label: '\u00AB',
        collapsed: false,
        view:new ol.View({
	          center:[110, 36], 
	          projection:'EPSG:4326',
	          zoom: 5
	        })
      });
      
      //创建一个交互选择对象  
       select = new ol.interaction.Select({  
          //水平包裹  
          //Wrap the world horizontally on the selection overlay 
          style:style_hightlight,
          wrapX: false  
      });  

      //创建一个交互修改对象  
       modify = new ol.interaction.Modify({  
        
          features: select.getFeatures()  
      }); 
       map=new ol.Map({
       
       	//添加全图浏览控件
       	controls: ol.control.defaults().extend([
          overviewMapControl
        ]),
        interactions: ol.interaction.defaults().extend([
          new ol.interaction.DragRotateAndZoom(),select, modify
        ]),
	            // 设置地图图层
	            layers: [
	              // 创建一个使用Open Street Map地图源的瓦片图层
	             vectorLayer,geoLayer
	            ],	            // 设置显示地图的视图
	            view: new ol.View({
	          center:[110, 36], 
	          projection:'EPSG:4326',
	          zoom: 4
	        }),
	            // 让id为map的div作为地图的容器
	            target: 'map'    
	        });
   </script>
	<script type="text/javascript" src ="js/map.js"></script>
  </body>
</html>


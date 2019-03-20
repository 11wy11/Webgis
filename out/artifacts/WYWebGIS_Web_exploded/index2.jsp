<%--
  Created by IntelliJ IDEA.
  User: huangguan
  Date: 2016/11/22
  Time: 10:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import ="com.wyjava.bean.testBean" %>
<%@ page import ="com.wyjava.bean.ConnectPostsql" %>
<%@ page import ="com.wyjava.bean.DBConnect" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
 <%ConnectPostsql c=new ConnectPostsql();
   c.init();
String str= c.getGeojson();%>
<html>
  <head>
    <title>贵州旅游电子地图集</title>
    <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
    <link rel="stylesheet" href="css/myhomePage.css"	type="text/css">
    <link rel="stylesheet" href="css/search_group.css" type="text/css">
  </head>
  <body>
  <div class="container-fluid">
    <div class="row" id="webbody">
      <div class="col-md-2" id="maplist">
        <!--左侧地图菜单-->
        <div class="panel-group" id="accordion" >
          <!--地图目录-->
          <div class="panel panel-default">
            <div class="panel-heading" id="panel-title-total">
              <h4 class="panel-title">
             		   地图目录
              </h4>
            </div>
          </div>

          <!--序图-->
          <div class="panel panel-default">
            <div id="collapseOne" class="panel-collapse collapse">
             
              <div class="panel-body">
                <li id="2001" class="basemapchange"><a> 贵州省在中国的地理位置 </a></li>
                <li id="2002" class="basemapchange"><a> 贵州政区 </a></li>
                <li id="2003" class="basemapchange"><a> 贵州卫星影像 </a></li>
                <li id="2004" class="basemapchange"><a> 贵州地势 </a></li>
                <li id="2005" class="basemapchange"><a> 贵州交通 </a></li>
              </div>
            </div>
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
   </div>
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
 
  <script>
    var map;
    require(["esri/map", "esri/layers/ArcGISDynamicMapServiceLayer","esri/layers/FeatureLayer",
      "esri/symbols/SimpleMarkerSymbol", "esri/symbols/SimpleLineSymbol",
      "esri/renderers/SimpleRenderer", "esri/graphic", "esri/lang",
      "esri/Color", "dojo/number", "dojo/dom-style",
      "dijit/TooltipDialog", "dijit/popup", "dojo/domReady!"],
            function (Map,ArcGISDynamicMapServiceLayer, FeatureLayer,
                      SimpleMarkerSymbol, SimpleLineSymbol,
                      SimpleRenderer, Graphic, esriLang,
                      Color, number, domStyle,
                      TooltipDialog, dijitPopup){
      map = new Map("map", {sliderOrientation : "horizontal"
      });
              map.on("load", function(){
                map.graphics.enableMouseEvents();
                map.graphics.on("mouse-out", closeDialog);

              });
      var layer = new ArcGISDynamicMapServiceLayer("http://192.168.1.108:6080/arcgis/rest/services/maptest/test_pyramid/MapServer");

      var hot=new FeatureLayer("http://192.168.1.108:6080/arcgis/rest/services/hoypot/MapServer/0",{
        mode: FeatureLayer.MODE_SNAPSHOT,
      });
              dialog = new TooltipDialog({
                id: "tooltipDialog",
                style: "position: absolute; width: 250px; font: normal normal normal 10pt Helvetica;z-index:100"
              });
              dialog.startup();

              var highlightSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_SQUARE, 10,
                      new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID,
                              new Color([255,0,0]), 1),
                      new Color([0,255,0,0.25]));

      hot.on("click", function(evt){
        var t = "hello";

        var content = esriLang.substitute(evt.graphic.attributes,t);
        var highlightGraphic = new Graphic(evt.graphic.geometry,highlightSymbol);
        map.graphics.add(highlightGraphic);

        dialog.setContent(content);

        domStyle.set(dialog.domNode, "opacity", 0.85);
        dijitPopup.open({
          popup: dialog,
          x: evt.pageX,
          y: evt.pageY

        });
      });
              function closeDialog() {
                map.graphics.clear();
                dijitPopup.close(dialog);
              }

      map.addLayer(layer);
      map.addLayer(hot);
    });
  </script>
</html>

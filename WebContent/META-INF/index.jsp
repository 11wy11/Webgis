<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import ="com.wyjava.bean.testBean" %>
<%@ page import ="com.wyjava.bean.ConnectPostsql" %>
<%@ page import ="com.wyjava.bean.DBConnect" %>
<%@ page import= "java.io.IOException"%>
<%@ page import ="java.io.PrintWriter"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>WebGIS实习</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">   
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<script type="text/javascript" src="http://www.openlayers.org/api/OpenLayers.js"></script>
	 <script src="https://openlayers.org/en/v4.2.0/build/ol.js"></script>
		<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<link rel="stylesheet" href="https://openlayers.org/en/v4.2.0/css/ol.css" type="text/css">
  </head>
  	
  <body >
    This is my JSP page <br>
    <div id="data"></div>
    <%
     testBean t =new testBean();
     t.test();
     %>    
    <div id="map" class="map"></div>
    <div id="info">&nbsp;</div>
    <script>
    var image = new ol.style.Circle({
        radius: 5,
        fill: null,
        stroke: new ol.style.Stroke({color: 'red', width: 1})
      });
    var styles = {
            'Point': new ol.style.Style({
              image: image
            }),
            'LineString': new ol.style.Style({
              stroke: new ol.style.Stroke({
                color: 'green',
                width: 1
              })
            }),
            'MultiLineString': new ol.style.Style({
              stroke: new ol.style.Stroke({
                color: 'green',
                width: 1
              })
            }),
            'MultiPoint': new ol.style.Style({
              image: image
            }),
            'MultiPolygon': new ol.style.Style({
              stroke: new ol.style.Stroke({
                color: 'yellow',
                width: 1
              }),
              fill: new ol.style.Fill({
                color: 'rgba(255, 255, 0, 0.1)'
              })
            }),
            'Polygon': new ol.style.Style({
              stroke: new ol.style.Stroke({
                color: 'blue',
                lineDash: [4],
                width: 3
              }),
              fill: new ol.style.Fill({
                color: 'rgba(0, 0, 255, 0.1)'
              })
            }),
            'GeometryCollection': new ol.style.Style({
              stroke: new ol.style.Stroke({
                color: 'magenta',
                width: 2
              }),
              fill: new ol.style.Fill({
                color: 'magenta'
              }),
              image: new ol.style.Circle({
                radius: 10,
                fill: null,
                stroke: new ol.style.Stroke({
                  color: 'magenta'
                })
              })
            }),
            'Circle': new ol.style.Style({
              stroke: new ol.style.Stroke({
                color: 'red',
                width: 2
              }),
              fill: new ol.style.Fill({
                color: 'rgba(255,0,0,0.2)'
              })
            })
          };

          var styleFunction = function(feature) {
            return styles[feature.getGeometry().getType()];
          };
      var style = new ol.style.Style({
        fill: new ol.style.Fill({
          color: 'rgba(255, 255, 255, 0.6)'
        }),
        stroke: new ol.style.Stroke({
          color: '#319FD3',
          width: 1
        }),
        text: new ol.style.Text({
          font: '12px Calibri,sans-serif',
          fill: new ol.style.Fill({
            color: '#000'
          }),
          stroke: new ol.style.Stroke({
            color: '#fff',
            width: 3
          })
        })
      });
      var geojsonObject = {
    	        'type': 'FeatureCollection',
    	        'crs': {
    	          'type': 'name',
    	          'properties': {
    	            'name': 'EPSG:3857'
    	          }
    	        },
                "features": [
    	        {"type": "Feature",
    	        "geometry": {"type":"Point","coordinates":[104183.776855469,365394.172668457]}
    	      }]
      };
      var vectorSource = new ol.source.Vector({
    	  projection:4326,
          features: (new ol.format.GeoJSON()).readFeatures(geojsonObject)
        });

        //vectorSource.addFeature(new ol.Feature(new ol.geom.Circle([2e6, 2e6], 1e6)));

        var vectorLayer = new ol.layer.Vector({
          source: vectorSource,
          style: styleFunction 
        });

        var map = new ol.Map({
          layers: [
            new ol.layer.Tile({
              source: new ol.source.OSM()
            }),
            vectorLayer
          ],
          target: 'map',
          controls: ol.control.defaults({
            attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
              collapsible: false
            })
          }),
          view: new ol.View({
            center:  ol.proj.transform([116.5, 39.5], 'EPSG:4326', 'EPSG:3857'),  
            zoom: 2
          })
        });
      </script>
  </body>
</html>

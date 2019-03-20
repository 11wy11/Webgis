var highlightStyleCache = {}, highlight;  
//弹出框需要的部件  
var container = document.getElementById('popup');  
var content = document.getElementById('popup-content');  
var closer = document.getElementById('popup-closer');  
  
/** 
 * 定义矢量图层 
 * 其中style是矢量图层的显示样式  
 */ 
var image = new ol.style.Circle({
    radius: 2,
    fill: null,
    stroke: new ol.style.Stroke({color: 'red', width: 1})
  });
 styles = {
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

      styleFunction = function(feature) {
        return styles[feature.getGeometry().getType()];
      };
      
  
var overlay = new ol.Overlay(/** @type {olx.OverlayOptions} */ ({  
	  element: container,  
	  autoPan: true,  
	  autoPanAnimation: {  
	    duration: 250   //当Popup超出地图边界时，为了Popup全部可见，地图移动的速度. 单位为毫秒（ms）  
	  }  
	}));  
	map.on('click', function(evt) {  
	  var pixel = map.getEventPixel(evt.originalEvent);  
	  var feature = map.forEachFeatureAtPixel(pixel, function(feature, layer) {  
	    return feature;  
	  });  
	  var coordinate = evt.coordinate;  
	  var hdms=ol.coordinate.toStringHDMS(coordinate);
	  if(feature!==undefined){  
	      content.innerHTML = '<p>你点击的坐标是：</p><code>' + hdms + '</code><p>这里属于：'+ feature.get('name') + '</p>'; 
	      show(feature.get('name'));
	  }  
	  else{  
	      content.innerHTML ='<p>你点击的坐标是：</p><code>' + hdms + '</code><p></p>';
	      addTable(coordinate);
	  }  
	  overlay.setPosition(coordinate);  
	  map.addOverlay(overlay);  
	});  
//显示属性信息
function show(name){
		$.ajax({ 
	    type : "GET", 
	    data:{//发送给数据库的数据
 			    name:encodeURI(name),
			 },
	    url : "Show.jsp", 
	    dataType : "text",		   
	    success : function(result) {
	    	 content.innerHTML =content.innerHTML+ result;
	    },
	    error:function(XMLHttpRequest, textStatus, errorThrown) {
			 alert(textStatus);
	    }   
	   });
}
function addTable(cor){
	//alert("lll");
	var geoinfo='Point('+cor+')';
	//alert(geoinfo);
	content.innerHTML =content.innerHTML+'<form id="addform" enctype="multipart/form-data" method="POST" action="addFeature.jsp" name="addform" target="update_iframe" ><table class="altrowstable" id="alternatecolor"><tr><th>城市详情</th></tr><tr><td width="30px" height="30px">城市名称：</td><td><input class="change_input" name="name" type="text" />'+
	'</td></tr><tr><td width="30px" height="30px">城市拼音：</td><td><input class="change_input" name="pinyin"type="text" /></td></tr><tr><td colspan="2" align="center" height="30px"><input type="file" name="img" class="file" id="addimg"  />'+
	'</td></tr><input  name="cooridnate" type="text" style="display:none" value="'+geoinfo+'"/><input type="submit" id="add_submit" name="add_submit" value="添加城市信息" /> <input type="reset"id="add_cancel" name="update_cancel" value="取消" />  ';
}
function show(name){
	$.ajax({ 
    type : "POST", 
    data:{//发送给数据库的数据
			    name:encodeURI(name),
		 },
    url : "Show.jsp", 
    dataType : "text",		   
    success : function(result) {
    	 content.innerHTML =content.innerHTML+ result;
    },
    error:function(XMLHttpRequest, textStatus, errorThrown) {
		 alert(textStatus);
    }   
   });
}
	/** 
	 * 隐藏弹出框的函数 
	 */  
	closer.onclick = function() {  
	  overlay.setPosition(undefined);  
	  closer.blur();  
	  return false;  
	}; 
	
	/*测距*/	
	document.querySelector("#measureControl").addEventListener('click', function() {
	if (measureActive) {
	 //关闭测距
	 measureActive = false;
	 
	 
	}
	else{
	//激活测距
	}
	});
	var wgs84Sphere = new ol.Sphere(6378137);

   var source = new ol.source.Vector();

     var vector = new ol.layer.Vector({
       source: source,
       style: new ol.style.Style({
         fill: new ol.style.Fill({
           color: 'rgba(255, 255, 255, 0.2)'
         }),
         stroke: new ol.style.Stroke({
           color: '#ffcc33',
           width: 2
         }),
         image: new ol.style.Circle({
           radius: 7,
           fill: new ol.style.Fill({
             color: '#ffcc33'
           })
         })
       })
     });


     /**
      * Currently drawn feature.
      * @type {ol.Feature}
      */
     var sketch;


     /**
      * The help tooltip element.
      * @type {Element}
      */
     var helpTooltipElement;


     /**
      * Overlay to show the help messages.
      * @type {ol.Overlay}
      */
     var helpTooltip;


     /**
      * The measure tooltip element.
      * @type {Element}
      */
     var measureTooltipElement;


     /**
      * Overlay to show the measurement.
      * @type {ol.Overlay}
      */
     var measureTooltip;


     /**
      * Message to show when the user is drawing a polygon.
      * @type {string}
      */
     var continuePolygonMsg = 'Click to continue drawing the polygon';


     /**
      * Message to show when the user is drawing a line.
      * @type {string}
      */
     var continueLineMsg = 'Click to continue drawing the line';


     /**
      * Handle pointer move.
      * @param {ol.MapBrowserEvent} evt The event.
      */
     var pointerMoveHandler = function(evt) {
       if (evt.dragging) {
         return;
       }
       /** @type {string} */
       var helpMsg = 'Click to start drawing';

       if (sketch) {
         var geom = (sketch.getGeometry());
         if (geom instanceof ol.geom.Polygon) {
           helpMsg = continuePolygonMsg;
         } else if (geom instanceof ol.geom.LineString) {
           helpMsg = continueLineMsg;
         }
       }

       helpTooltipElement.innerHTML = helpMsg;
       helpTooltip.setPosition(evt.coordinate);

       helpTooltipElement.classList.remove('hidden');
     };
     var map1 = this.getMap();
     map1.addLayer(vector);
     map1.on('pointermove', pointerMoveHandler);

     map1.getViewport().addEventListener('mouseout', function() {
       helpTooltipElement.classList.add('hidden');
     });

     var typeSelect = document.getElementById('type');
     var geodesicCheckbox = document.getElementById('geodesic');

     var draw; // global so we can remove it later

     /**
      * Let user change the geometry type.
      */
     typeSelect.onchange = function() {
    	map1.removeInteraction(draw);
       addInteraction();
     };
     addInteraction();
     /**
      * Format length output.
      * @param {ol.geom.LineString} line The line.
      * @return {string} The formatted length.
      */
     var formatLength = function(line) {
       var length;
       if (geodesicCheckbox.checked) {
         var coordinates = line.getCoordinates();
         length = 0;
         var sourceProj = map.getView().getProjection();
         for (var i = 0, ii = coordinates.length - 1; i < ii; ++i) {
           var c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
           var c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326');
           length += wgs84Sphere.haversineDistance(c1, c2);
         }
       } else {
         length = Math.round(line.getLength() * 100) / 100;
       }
       var output;
       if (length > 100) {
         output = (Math.round(length / 1000 * 100) / 100) +
             ' ' + 'km';
       } else {
         output = (Math.round(length * 100) / 100) +
             ' ' + 'm';
       }
       return output;
     };


     /**
      * Format area output.
      * @param {ol.geom.Polygon} polygon The polygon.
      * @return {string} Formatted area.
      */
     var formatArea = function(polygon) {
       var area;
       if (geodesicCheckbox.checked) {
         var sourceProj = map.getView().getProjection();
         var geom = /** @type {ol.geom.Polygon} */(polygon.clone().transform(
             sourceProj, 'EPSG:4326'));
         var coordinates = geom.getLinearRing(0).getCoordinates();
         area = Math.abs(wgs84Sphere.geodesicArea(coordinates));
       } else {
         area = polygon.getArea();
       }
       var output;
       if (area > 10000) {
         output = (Math.round(area / 1000000 * 100) / 100) +
             ' ' + 'km<sup>2</sup>';
       } else {
         output = (Math.round(area * 100) / 100) +
             ' ' + 'm<sup>2</sup>';
       }
       return output;
     };

     function addInteraction() {
       var type = (typeSelect.value == 'area' ? 'Polygon' : 'LineString');
       draw = new ol.interaction.Draw({
         source: source,
         type: /** @type {ol.geom.GeometryType} */ (type),
         style: new ol.style.Style({
           fill: new ol.style.Fill({
             color: 'rgba(255, 255, 255, 0.2)'
           }),
           stroke: new ol.style.Stroke({
             color: 'rgba(0, 0, 0, 0.5)',
             lineDash: [10, 10],
             width: 2
           }),
           image: new ol.style.Circle({
             radius: 5,
             stroke: new ol.style.Stroke({
               color: 'rgba(0, 0, 0, 0.7)'
             }),
             fill: new ol.style.Fill({
               color: 'rgba(255, 255, 255, 0.2)'
             })
           })
         })
       });
       map.addInteraction(draw);

       createMeasureTooltip();
       createHelpTooltip();

       var listener;
       draw.on('drawstart',
           function(evt) {
             // set sketch
             sketch = evt.feature;

             /** @type {ol.Coordinate|undefined} */
             var tooltipCoord = evt.coordinate;

             listener = sketch.getGeometry().on('change', function(evt) {
               var geom = evt.target;
               var output;
               if (geom instanceof ol.geom.Polygon) {
                 output = formatArea(geom);
                 tooltipCoord = geom.getInteriorPoint().getCoordinates();
               } else if (geom instanceof ol.geom.LineString) {
                 output = formatLength(geom);
                 tooltipCoord = geom.getLastCoordinate();
               }
               measureTooltipElement.innerHTML = output;
               measureTooltip.setPosition(tooltipCoord);
             });
           }, this);

       draw.on('drawend',
           function() {
             measureTooltipElement.className = 'tooltip tooltip-static';
             measureTooltip.setOffset([0, -7]);
             // unset sketch
             sketch = null;
             // unset tooltip so that a new one can be created
             measureTooltipElement = null;
             createMeasureTooltip();
             ol.Observable.unByKey(listener);
           }, this);
     }


     /**
      * Creates a new help tooltip
      */
     function createHelpTooltip() {
       if (helpTooltipElement) {
         helpTooltipElement.parentNode.removeChild(helpTooltipElement);
       }
       helpTooltipElement = document.createElement('div');
       helpTooltipElement.className = 'tooltip hidden';
       helpTooltip = new ol.Overlay({
         element: helpTooltipElement,
         offset: [15, 0],
         positioning: 'center-left'
       });
       map.addOverlay(helpTooltip);
     }


     /**
      * Creates a new measure tooltip
      */
     function createMeasureTooltip() {
       if (measureTooltipElement) {
         measureTooltipElement.parentNode.removeChild(measureTooltipElement);
       }
       measureTooltipElement = document.createElement('div');
       measureTooltipElement.className = 'tooltip tooltip-measure';
       measureTooltip = new ol.Overlay({
         element: measureTooltipElement,
         offset: [0, -15],
         positioning: 'bottom-center'
       });
       map.addOverlay(measureTooltip);
     }


     
	
	
	
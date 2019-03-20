/*--------------------------------------弹窗--------------------------------------------*/
/**
 * 弹窗
 */
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

	/** 
	 * 隐藏弹出框的函数 
	 */  
	closer.onclick = function() {  
	  overlay.setPosition(undefined);  
	  closer.blur();  
	  return false;  
	}; 
	$(document).ready(function(e) {
	    $("#measureControl").click(function(e) {
	    	window.location.href="measure.jsp";	
	    });
	 });

     /*--------------------------------------拉框放大缩小-------------------------------------------------------------*/
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
        dragZoom.setActive(false);
        dragZoom1.setActive(false);
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
       dragAndDropInteraction.on('addfeatures', function(event) {
         var vectorSource = new ol.source.Vector({
           features: event.features
         });
         map.addLayer(new ol.layer.Vector({
           source: vectorSource,
           style: styleFunction
         }));
         map.getView().fit(vectorSource.getExtent());
       });

       var displayFeatureInfo = function(pixel) {
         var features = [];
         map.forEachFeatureAtPixel(pixel, function(feature) {
           features.push(feature);
         });
         if (features.length > 0) {
           var info = [];
           var i, ii;
           for (i = 0, ii = features.length; i < ii; ++i) {
             info.push(features[i].get('name'));
           }
           document.getElementById('info').innerHTML = info.join(', ') || '&nbsp';
         } else {
           document.getElementById('info').innerHTML = '&nbsp;';
         }
       };

       map.on('pointermove', function(evt) {
         if (evt.dragging) {
           return;
         }
         var pixel = map.getEventPixel(evt.originalEvent);
         displayFeatureInfo(pixel);
       });

       map.on('click', function(evt) {
         displayFeatureInfo(evt.pixel);
       });
     
       
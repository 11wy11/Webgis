var map = new ol.Map({  
        target: 'map',  
        layers: [  
          new ol.layer.Tile({  
            source: new ol.source.OSM() 
          })  
        ],  
        view: new ol.View({  
          center: ol.proj.transform([37.41, 8.82], 'EPSG:4326', 'EPSG:3857'),  
          zoom: 4  
        })  
      });
var container = document.getElementById('popup');  
var content = document.getElementById('popup-content');  
var closer = document.getElementById('popup-closer');  
  
  
/** 
 * Add a click handler to hide the popup. 
 * @return {boolean} Don't follow the href. 
 */  
closer.onclick = function() {  
  overlay.setPosition(undefined);  
  closer.blur();  
  return false;  
};  
  
  
/** 
 * Create an overlay to anchor the popup to the map. 
 */  
var overlay = new ol.Overlay(/** @type {olx.OverlayOptions} */ ({  
  element: container,  
  autoPan: true,  
  autoPanAnimation: {  
    duration: 250   //当Popup超出地图边界时，为了Popup全部可见，地图移动的速度. 单位为毫秒（ms）  
  }  
}));  
  
  
/** 
 * Add a click handler to the map to render the popup. 
 */  
map.addEventListener('click', function(evt) {  
  var coordinate = evt.coordinate;  
  var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(  
      coordinate, 'EPSG:3857', 'EPSG:4326'));  
  content.innerHTML = '<p>你点击的坐标是：</p><code>' + hdms + '</code>';  
  overlay.setPosition(coordinate);  
  map.addOverlay(overlay);  
});
 
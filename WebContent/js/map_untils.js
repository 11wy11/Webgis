function init(geojson)
{
	var image = new ol.style.Circle({
        radius: 2,
        fill: new ol.style.Fill({color: 'green'}),
        stroke: new ol.style.Stroke({color: 'green', width: 1})
      });

      var style = new ol.style.Style({
          image: image
        });

      var myGeoJSON =geojson;
     
      var vectorSource = new ol.source.Vector({
        features: (new ol.format.GeoJSON()).readFeatures(myGeoJSON,
        ({
          dataProjection: "EPSG::4326",
          featureProjection:"EPSG::3857"}))
      });

      var vectorLayer = new ol.layer.Vector({
        source: vectorSource,
        style: style
      });
        
        new ol.Map({
            // 设置地图图层
            layers: [
              // 创建一个使用Open Street Map地图源的瓦片图层
              new ol.layer.Tile({source: new ol.source.OSM()}),
              vectorLayer
            ],
            // 设置显示地图的视图
            view: new ol.View({
          center:[110, 36], 
          projection:'EPSG:4326',
          zoom: 4
        }),
            // 让id为map的div作为地图的容器
            target: 'map'    
        });
	      	
}
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
<!DOCTYPE html>
<html>
  <head>
    <title>Measure</title>
    <link rel="stylesheet" href="https://openlayers.org/en/v4.2.0/css/ol.css" type="text/css">
    <!-- 弹出窗样式 -->
<link rel="stylesheet" href="css/overview.css">
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v4.2.0/build/ol.js"></script>
    <style>
      .tooltip {
        position: relative;
        background: rgba(0, 0, 0, 0.5);
        border-radius: 4px;
        color: white;
        padding: 4px 8px;
        opacity: 0.7;
        white-space: nowrap;
      }
      .tooltip-measure {
        opacity: 1;
        font-weight: bold;
      }
      .tooltip-static {
        background-color: #ffcc33;
        color: black;
        border: 1px solid white;
      }
      .tooltip-measure:before,
      .tooltip-static:before {
        border-top: 6px solid rgba(0, 0, 0, 0.5);
        border-right: 6px solid transparent;
        border-left: 6px solid transparent;
        content: "";
        position: absolute;
        bottom: -6px;
        margin-left: -7px;
        left: 50%;
      }
      .tooltip-static:before {
        border-top-color: #ffcc33;
      }    </style>
  </head>
  <body>
    <div id="map" class="map"></div>
    <form class="form-inline">
      <label>Measurement type &nbsp;</label>
        <select id="type">
          <option value="length">长度</option>
          <option value="area">面积</option>
        </select>
        <label class="checkbox">
          <input type="checkbox" id="geodesic">
          use geodesic measures
        </label>
    </form>
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
      var wgs84Sphere = new ol.Sphere(6378137);

      var raster = new ol.layer.Tile({
        source: new ol.source.OSM()
      });

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
      var continuePolygonMsg = '点击继续绘制多边形';


      /**
       * Message to show when the user is drawing a line.
       * @type {string}
       */
      var continueLineMsg = '点击继续绘制线';


      /**
       * Handle pointer move.
       * @param {ol.MapBrowserEvent} evt The event.
       */
      var pointerMoveHandler = function(evt) {
        if (evt.dragging) {
          return;
        }
        /** @type {string} */
        var helpMsg = '点击开始绘制';

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
           /*鼠标坐标 */
   		 var mousePositionControl= new ol.control.MousePosition({
         coordinateFormat: ol.coordinate.createStringXY(4),
        projection: 'EPSG:4326',
        className: 'custom-mouse-position',
        target: document.getElementById('mouse-position')
        });
      var map = new ol.Map(
				{

					//添加全图浏览控件
					controls : ol.control.defaults().extend(
							[ overviewMapControl,scaleLineControl,
							//mousePositionControl
							]),
					interactions : ol.interaction.defaults().extend(
							[ new ol.interaction.DragRotateAndZoom(),//地图旋转功能
							
									]),
					// 设置地图图层
					layers:[
					osm,vectorLayer,vector],
					// 设置显示地图的视图
					view : new ol.View({
						center : [ 110, 36 ],
						projection : 'EPSG:4326',
						zoom : 4
					}),
					// 让id为map的div作为地图的容器
					target : 'map'
				});

      map.on('pointermove', pointerMoveHandler);

      map.getViewport().addEventListener('mouseout', function() {
        helpTooltipElement.classList.add('hidden');
      });

      var typeSelect = document.getElementById('type');
      var geodesicCheckbox = document.getElementById('geodesic');

      var draw; // global so we can remove it later


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
           /*  var c1 = ol.proj.transform(coordinates[i], sourceProj, 'EPSG:4326');
            var c2 = ol.proj.transform(coordinates[i + 1], sourceProj, 'EPSG:4326'); */
            var c1=coordinates[i];
            var c2=coordinates[i+1];
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


      /**
       * Let user change the geometry type.
       */
      typeSelect.onchange = function() {
        map.removeInteraction(draw);
        addInteraction();
      };

      addInteraction();
    </script>
  </body>
</html>

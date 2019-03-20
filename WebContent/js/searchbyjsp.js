/*<!-- 用户登录验证/注册/退出/权限控制 -->*/
function searchName_ajax(){	
	//管理员登录
	 if(document.getElementById("username").value!=null)
	{
		 //alert("管理员模式");
		   var cityname =encodeURI(encodeURI($("#cityname").val()));//
		   if(cityname=""){
		    alert("请输入城市名称");
		    return;
		   	}
		    $("#resText").html(cityname);
		    var text =document.getElementById("resText");
			$.ajax({ 
		    type : "GET", 
		    data:{//发送给数据库的数据
	   			    name:encodeURI(encodeURI($("#cityname").val())),
	  			 },
		    url : "update.jsp", 
		    dataType : "text",		   
		    success : function(result) {
		    	$("#attr_table").html(result);
		    	var geoObject =document.getElementById("hid").innerHTML;		    
		    	showFeature(geoObject);
		    	$("#update_iframe").css("display:block");
		    },
		    error:function(XMLHttpRequest, textStatus, errorThrown) {
				 alert(textStatus);
		    }   
		   }); 
	}
	//用户登录
	 else
	 {
		 alert("用户模式！");
		 var cityname =encodeURI(encodeURI($("#cityname").val()));//
		   if(cityname=""){
		    alert("请输入城市名称");
		    return;
		   	}
		    $("#resText").html(cityname);
		    var text =document.getElementById("resText");
			$.ajax({ 
		    type : "GET", 
		    data:{//发送给数据库的数据
	   			    name:encodeURI(encodeURI($("#cityname").val())),
	  			 },
		    url : "Show.jsp", 
		    dataType : "text",
		    //contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
		    success : function(result) {
		    	$("#attr_table").html(result);
		    	var geoObject =document.getElementById("hid").innerHTML;
		    	//alert(geoObject);
		    	showFeature(geoObject);
		    },
		    error:function(XMLHttpRequest, textStatus, errorThrown) {
				 //alert(XMLHttpRequest.status);
				 //alert(XMLHttpRequest.readyState);
				 alert(textStatus);
		    }   
		   }); 
		 
	 }
}
 function showFeature(result){
		if(result==null)
	    {
	      alert("未查询到结果！请重新输入！");
	      $("#cityname").html("");
	    }
	      //$("#resText").html(result);
	      //alert(result);
	       if(vectorLayer1){
	       map.removeLayer(map.getLayers().item(3));
	      }      
	      var vectorSource1 = new ol.source.Vector({
		        features: (new ol.format.GeoJSON()).readFeatures(result,
		        ({
		          dataProjection: "EPSG::4326",
		          featureProjection:"EPSG::3857"}))
		      });
		   vectorLayer1 = new ol.layer.Vector({
		        source: vectorSource1,
		        style: style_hightlight
		      });
		  map.addLayer(vectorLayer1);
}

/*查询请求用户登录验证/注册/退出/权限控制*/
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
		    	$("#attr_table").html(result+'<a id="attr_closer" class="ol-popup-closer" ></a>');
		    	/* var attr_closer = document.createElement('a');
		         attr_closer.className ='ol-popup-closer';
		    	$("#attr_table").appendChild(attr_closer);*/
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
/**
 * 显示矢量要素
 * @param result geojson数据
 */
 function showFeature(result){
		if(result==null)
	    {
	      alert("未查询到结果！请重新输入！");
	      $("#cityname").html("");
	    }
	       if(vectorLayer1){
	      // map.removeLayer(map.getLayers().item(2));
	    	  map.removeLayer(vectorLayer1);
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

/**
 * 上传图片
 */
function sendImage(){
	alert("sendImage");
		var xhr1;
		 var picname =$("#picname").val();
		 if(picname=""){
		    alert("请输入城市名称");
		    return;
		   	}
		   	alert(picname);
		var form = new FormData(); // FormData 对象	
		var queryString ="servlet/UploadFile?name="+picname;
		//创建xmlhttprequest
		if (window.ActiveXObject)
			xhr1 = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest)
			xhr1 = new XMLHttpRequest();
		if (document.getElementById("img").value != "")
		{
			var fileObj = document.getElementById("img").files[0]; // js 获取文件对象
			form.append("mf", fileObj); // 文件对象
		}
	xhr1.open("POST", queryString);
	xhr1.send(form);
	xhr1.onreadystatechange=function(e)
	{
	    if(xhr1.readyState==4&&xhr1.status==200)
	     {
	     alert("更新成功！");
	     }
	}
}
var array;
var dgreeChart= function (sql){
	$.ajax({ 
    type : "GET", 
    data:{//发送给数据库的数据
			    sql:sql,
		 },
    url : "servlet/CheckName", 
    dataType : "text",		   
    success : function(result) {
    //alert("后台结果"+result);
    var obj = JSON.parse(result);
    //alert(obj)
    array=obj.features;
    console.log(array);
    statis();
    },
    error:function(XMLHttpRequest, textStatus, errorThrown) {
		 alert(textStatus);
    }   
   });

}
var  changey=function(str){
if(str=="2"){
  return "一线城市";
}
else if(str=="1"){
 return "首都城市";
}
else if(str=="3"){
 return "二线城市";
}
else if(str=="9"){
 return "特别行政区";
}else{
 return "其他城市";
}
}
/* 调用ajax请求查询结果 */
function statis() {	
//alert("统计图函数："+array);
var str="";
 for(var i=0,l=array.length;i<l;i++){
 if(i==0){
 str=str+"{name:'"+changey(array[i].adclass)+"',y:"+array[i].y+",sliced: true,selected: true},";
 }
 else{
 str=str+"['"+changey(array[i].adclass)+"',"+array[i].y+"],";
 }
	}

str=str.substring(0, str.length-1);
str="["+str+"]";
//alert("绘制数据："+str);
console.log(str);
str=eval(str);
$('#container').highcharts({
    chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false
    },
    title: {
        text: '各城市分布统计图'
    },
    tooltip: {
        headerFormat: '{series.name}<br>',
        pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
                enabled: false
            },
            showInLegend: true
        }
    },
    series: [{
        type: 'pie',
        name: '地区城市数',
        data: str      
    }]
});
}
//翻译
var  changeYouname=function(str){
if(str=="2"){
  return "一线城市";
}
else if(str=="1"){
 return "首都城市";
}
else if(str=="3"){
 return "二线城市";
}
else if(str=="9"){
 return "特别行政区";
}else{
 return "其他城市";
}
}
/*柱形图  */
var changeYouname=function(name){
	if(name==1){
	   return "华北";		  
	}
	else if(name==2){
	return "东北";
	 } 
	 else if(name==3){
	 return "华东";
	 }		 
	else if(name==4){
	 return "中南";
	 } 
	else if(name==5){
	 return "西南";
	 } 
	else if(name==6){		
	 return "西北";
	 }
	else if(name==7){		
	 return "台湾";
	 }
	else if(name==8){	
 	return "特别行政区";			 
	 }
	 else{
	 return "其他";
		 }
}
function columnChart()
{
//alert("统计图函数："+array);
var str="";
 for(var i=0,l=array.length;i<l;i++){
 if(i==0){
 str=str+"{name:'"+"其他"+"',y:"+array[i].y+",drilldown: null},";
 }
 else{
 str=str+"{name:'"+array[i].province+"',y:"+array[i].y+",drilldown: null},";
 }
	}	
str=str.substring(0, str.length-1);
str="["+str+"]";
console.log(str);
str=eval(str);
// Create the chart
Highcharts.chart('container1', {
    chart: {
        type: 'column'
    },
    title: {
        text: '各省城市数统计'
    },
    subtitle: {
        text: '邮编统计'
    },
    xAxis: {
        type: '省份'
    },
    yAxis: {
        title: {
            text: '城市数'
        }
    },
    legend: {
        enabled: false
    },
    plotOptions: {
        series: {
            borderWidth: 0,
            dataLabels: {
                enabled: true,
                format: '{point.y:.f}'
            }
        }
    },
    tooltip: {
        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.f}</b> of total<br/>'
    },
    series: [{
        name: '省份',
        colorByPoint: true,
        data: str
     }]
});
}
/* subareaChart */
var subareaChart= function (sql){
	$.ajax({ 
    type : "GET", 
    data:{//发送给数据库的数据
			    sql:sql,
		 },
    url : "servlet/CheckName", 
    dataType : "text",		   
    success : function(result) {
    //alert("后台结果"+result);
    var obj = JSON.parse(result);
    //alert(obj)
    array=obj.features;
    console.log(array);
    columnChart();
    },
    error:function(XMLHttpRequest, textStatus, errorThrown) {
		 alert(textStatus);
    }   
   });

}
/* zoneChart*/
var zoneChart= function (sql){
	$.ajax({ 
    type : "GET", 
    data:{//发送给数据库的数据
			    sql:sql,
		 },
    url : "servlet/GetZone", 
    dataType : "text",		   
    success : function(result) {
    //alert("后台结果"+result);
    var obj = JSON.parse(result);
    //alert(obj)
    array=obj.features;
    console.log(array);
    columnZoneChart();
    },
    error:function(XMLHttpRequest, textStatus, errorThrown) {
		 alert(textStatus);
    }   
   });

}
function columnZoneChart()
{
//alert("统计图函数："+array);
var str="";
 for(var i=0,l=array.length;i<l;i++){
 str=str+"{name:'"+changeYouname(array[i].name)+"',y:"+array[i].y+",drilldown: null},";
	}	
str=str.substring(0, str.length-1);
str="["+str+"]";
console.log(str);
str=eval(str);
// Create the chart
Highcharts.chart('container2', {
    chart: {
        type: 'column'
    },
    title: {
        text: '各地区城市数统计'
    },
    subtitle: {
        text: '根据邮编统计'
    },
    xAxis: {
        type: '地区'
    },
    yAxis: {
        title: {
            text: '城市数'
        }
    },
    legend: {
        enabled: true
    },
    plotOptions: {
        series: {
            borderWidth: 0,
            dataLabels: {
                enabled: true,
                format: '{point.y:.f}'
            }
        }
    },
    tooltip: {
        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
        pointFormat: '<span style="color:{point.color}">{point.name}</span>: 该区包含<b>{point.y:.f}</b>个城市 <br/>'
    },
    series: [{
        name: '地区',
        colorByPoint: true,
        data: str
     }]
});
}
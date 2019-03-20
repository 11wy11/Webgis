function changeImage(obj){  
            obj.src = "servlet/GetAuthCode?="+Math.random();  
        }  
function login(){
//alert("login");
	Save();
$.ajax({ 
	    type : "GET", 
	    data:{
   			    username:encodeURI(encodeURI($("#username").val())),
   			    password:encodeURI(encodeURI($("#password").val())),
   			    authCode:encodeURI(encodeURI($("#authCode").val()))
  			 },
	    url : "servlet/LoginServlet", 
	    dataType : "text",
	    success : function(result) {
	     //alert(result);
	    if(result==2){
	    isAdmin=2;
	    $("#Validate").html("恭喜"+$("#username").val()+"登录成功");
	    window.location.href="mainindex.jsp";
	    }
	   	else{
	    $("#Validate").html(result);
	    }
	    },
	    error:function(XMLHttpRequest, textStatus, errorThrown) {
			 alert("faile");
			 alert(textStatus);
	    }   
	   }); 
}
function signUp(){
$.ajax({ 
    type : "GET", 
    data:{//发送给数据库的数据
		    username:encodeURI(encodeURI($("#username").val())),
		    authCode:encodeURI(encodeURI($("#authCode").val())),
		    password:encodeURI(encodeURI($("#password").val()))
		 },
    url : "servlet/SignUp", 
    dataType : "text", 
    success : function(result) {
    //alert(result);
	    if(result==2){
	    $("#Validate").html("恭喜"+$("#username").val()+"注册成功");
	    isAdmin=2;
	    window.location.href="mainindex.jsp";
	    
	    }
	   	else{
	    $("#Validate").html(result);
	    }
    },
    error:function(XMLHttpRequest, textStatus, errorThrown) {
		 //alert(XMLHttpRequest.status);
		 //alert(XMLHttpRequest.readyState);
			 alert(textStatus);
	    }   
	   }); 
}


//记住用户名密码
function Save() {
  if ($("#rembUser").attr("checked")) {
    var str_username = $("#username").val();
    var str_password = $("#password").val();
    var expiresDate= new Date();
    expiresDate.setTime(expiresDate.getTime() + (30* 60 * 1000));
    //?替换成分钟数如果为60分钟则为 60 * 60 *1000
    $.cookie("rmbUser", "true", {path:'/', expires: expiresDate }); //存储一个带30分钟期限的cookie
    $.cookie("username", str_username, {path:'/', expires:expiresDate });
    $.cookie("password", str_password, {path:'/', expires: expiresDate });
  }
  else {
    $.cookie("rmbUser", "false", { expire: -1 });
    $.cookie("username", "", { expires: -1 });
    $.cookie("password", "", { expires: -1 });
  }
};
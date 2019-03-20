<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>登陆界面</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="stylesheet"
	href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="css/main.css">
<script
	src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script
	src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://img.hcharts.cn/jquery/jquery-1.8.3.min.js"></script>
	<script type="text/javascript" src="js/jquery.cookie.js"></script>
</head>
<body style="background:url(images/hr_login.jpg); background-size: cover; ">
	<div class="box">
		<div class="cnt" style="background-color:#79CDCD ;margin-left:45%">
			<p id="huanying">
				<span id="cnt_one">欢迎登录</span>
			</p>
			<hr />
			<div>
				<form class="bs-example bs-example-form" role="form">
					<div class="input-group">
						<span class="input-group-addon"><img src="images/use.png">
						</span> <input type="text" class="form-control" id="username"
							name="username" placeholder="请输入您的账号">
					</div>
					<br>
					<div class="input-group">
						<span class="input-group-addon"><img src="images/suo.png">
						</span> <input type="password" class="form-control" id="password"
							name="password" placeholder="请输入您的密码">
					</div>
					<br>
					<div class="input-group" style="position:absolute;">
						<input type="text" class="form-control" placeholder="请输入验证码"
							id="authCode" name="authCode"
							style="position:relative;width:191px;height:33px;"> <img
							src="servlet/GetAuthCode" border="0" alt="验证码,看不清楚?请点击刷新验证码"
							style="cursor:pointer; margin:10 10" onclick="changeImage(this)" />
						
						<div style="margin-top:40px;">
						<label> <input type="checkbox" name="remember_me"
					id="rembUser"> 记住密码 </label>
						<input class="btn btn-primary"
								type="button" value="登录" onclick="login()" /> 
							<input class="btn btn-primary" type="button" value="注册"
								onclick="signUp()" /> <input
								class=" btn btn-primary" type="reset" value="重置" />
						</div>
						<div id="Validate"></div>
					</div>
					<br>
				</form>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	$(document).ready(function(e) {
	 if ($.cookie("rmbUser") == "true") {
  $("#rmbUser").attr("checked", true);
  $("#username").val($.cookie("username"));
  $("#password").val($.cookie("password"));
  }
  });
	
	</script>
	<script type="text/javascript" src="js/validate.js">  </script>
</body>
</html>

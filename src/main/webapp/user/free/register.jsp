<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<script type="text/javascript">
	var canSubmit = true;
	function valName() {
		var pattern = new RegExp("^[a-z]([a-z0-9])*[-_]?([a-z0-9]+)$", "i"); //创建模式对象
		var str1 = document.getElementById("name").value; //获取文本框的内容

		if (str1 == null || str1 == "") {
			document.getElementById("namespan").innerHTML = "*不能为空";
			return false;
		} else if (str1.length >= 8 && pattern.test(str1)) { //pattern.test() 模式如果匹配，会返回true，不匹配返回false
			document.getElementById("namespan").innerHTML = "ok";
			return true;
		} else {
			document.getElementById("namespan").innerHTML = "*至少需要8个字符，以字母开头，以字母或数字结尾，可以有-和_";
			return false;
		}
	}

	function valPassword() {
		var str = document.getElementById("password").value;
		var pattern = /^(\w){6,20}$/;

		if (document.getElementById("password").value == null || document.getElementById("password").value == "") {
			document.getElementById("passwordspan").innerHTML = "*不能为空";
			return false;
		} else if (str.match(pattern) == null) {
			document.getElementById("passwordspan").innerHTML = "*只能输入6-20个字母、数字、下划线";
			return false;
		} else {
			document.getElementById("passwordspan").innerHTML = "ok";
			return true;
		}
	}

	function passwordSame() {
		var str = document.getElementById("password").value;
		if (document.getElementById("password2").value == null || document.getElementById("password2").value == "") {
			document.getElementById("passwordspan2").innerHTML = "*不能为空";
			return false;
		} else if (document.getElementById("password").value == document.getElementById("password2").value) {
			document.getElementById("passwordspan2").innerHTML = "ok";
			return true;
		} else {
			document.getElementById("passwordspan2").innerHTML = "*两次密码不一样";
			return false;
		}

	}
	function emailCheck() {
		var pattern = new RegExp("^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$", "i"); //创建模式对象
		var str1 = $("#email").val(); //获取文本框的内容

		if (str1.length >= 8 && pattern.test(str1)) { //pattern.test() 模式如果匹配，会返回true，不匹配返回false
			$("#emailSpan").html("ok");
			return true;
		} else {
			$("#emailSpan").html("电子邮箱格式错误!");
			canSubmit = false;
			return false;
		}
	}
	$("#email").blur(function() { //为id是userName的标签绑定  失去焦点事件  的处理函数
		check(email, "", emailSpan,
			"ok", "电子邮箱格式错误!");
	});

	$("#checkImg").click(function() { //为id是checkImg的标签绑定  鼠标单击事件  的处理函数
		//$(selector).attr(attribute,value)  设置被选元素的属性值
		//网址后加如一个随机值rand，表示了不同的网址，防止缓存导致的图片内容不变
		$("#checkImg").attr("src", "/news/servlet/ImageCheckCodeServlet?rand=" + Math.random());
	});
	$(document).ready(function() { //资源加载后才执行的 代码，就放到这个函数中，jquery能保证网页所有资源（html代码，图片，js文件，css文件等）都加载后，才执行此函数

		$("#userName").blur(function() { //为id是userName的标签绑定  失去焦点事件  的处理函数
			check(userName, "^[a-z]([a-z0-9])*[-_]?([a-z0-9]+)$", userNameSpan,
				"ok", "*用户名至少需要3个字符，必须以字母开头，以字母或数字结尾，可以有-和_");
		});

		$("#password").blur(function() { //为id是userName的标签绑定  失去焦点事件  的处理函数
			check(password, "^[a-z]([a-z0-9])*[-_]?([a-z0-9]+)$", passwordSpan,
				"ok", "*用户名至少需要8个字符，必须以字母开头，以字母或数字结尾，可以有-和_");
		});

		$("#email").blur(function() { //为id是userName的标签绑定  失去焦点事件  的处理函数
			check(email, "", emailSpan,
				"ok", "电子邮箱格式错误!");
		});

		$("#checkImg").click(function() { //为id是checkImg的标签绑定  鼠标单击事件  的处理函数
			//$(selector).attr(attribute,value)  设置被选元素的属性值
			//网址后加如一个随机值rand，表示了不同的网址，防止缓存导致的图片内容不变
			$("#checkImg").attr("src", "/news/servlet/ImageCheckCodeServlet?rand=" + Math.random());
		});

		$("#button").click(function() {
			canSubmit = true;

			if (!emailCheck())
				alert("电子邮箱格式错误!"); //阻止提交	    	    	
			else if ($("#checkCode").val() == "")
				alert("必须输入验证码！"); //
			else { //客户端数据验证通过
				$.ajax({ //验证码检测
					url : "/news/servlet/UserServlet?type1=register",
					type : "post",
					data : $("#form1").serialize(), //serialize():搜集表单元素数据，并形成查询字符串
					dataType : "json",
					cache : false,
					error : function(textStatus, errorThrown) { //ajax请求失败时，将会执行此回调函数
						alert("系统ajax交互错误: " + textStatus);
					},
					success : function(data, textStatus) { //ajax请求成功时，会执行此回调函数
						if (data.result == 1) { //注册成功
							var newHtml = "注册成功！<br/>" +
								"<a href='login.jsp'>登录</a><br/>" +
								"<a href='/news/index.jsp'>返回前端主页</a>";
							$("#myDiv").html(newHtml);
						} else if (data.result == 0) { //数据库操作失败
							alert("同名用户已存在，请改名重新注册！");
						} else if (data.result == -1) { //有同名用户
							alert("有同名用户！");
							$("#userNameSpan").html("用户名已注册，请换一个用户名！");
						} else if (data.result == -10) { //emai已被注册
							alert("emai已被注册！");
							$("#emailSpan").html("emai已被注册，请换一个email！");
						} else if (data.result == -3) { //服务器端验证图片验证码不存在
							alert("验证码不存在！请点击验证码生成新的验证码");
							$("#checkCode").val(""); //清空文本框
						} else if (data.result == -4) { //验证码错误
							alert("验证码错误，请重新输入验证码！");
							$("#checkCode").val("");
						}
					}
				});
			}
		});
	});
</script>
</head>

<body style="align:center;">
	<div id="myDiv"
		style="margin-left:auto;margin-right:auto;width:800px;margin-top:50px;">
		<form id="form1" name="form1"
			action="/news/servlet/UserServlet?type1=register" method="post">
			<div class="center" style="width:600px;margin-top:40px">
				<table border="0" align="center">
					<tbody>
						<tr height="30">
							<td></td>
							<td>注册</td>
						</tr>
						<tr height="30">
							<td align="right">用户类型：</td>
							<td><select name="type">
									<option value="user">普通用户</option>
									<option value="newsAuthor">新闻发布员</option>
									<option value="manager">管理员</option>
							</select></td>
						</tr>
						<tr height="30">
							<td align="right">用户名：</td>
							<td align="left"><input type="text" name="name" id="name"
								onBlur="valName()"> <br> <span id="namespan"
								style="color: #E7060A;"></span></td>
						</tr>
						<tr height="30">
							<td align="right">密码：</td>
							<td align="left"><input type="password" name="password"
								id="password" onBlur="valPassword()"> <br> <span
								id="passwordspan" style="color: #E7060A;"></span></td>
						</tr>
						<tr height="30">
							<td align="right">重新输入密码：</td>
							<td align="left"><input type="password" name="password2"
								id="password2" onBlur="passwordSame()"> <br> <span
								id="passwordspan2" style="color: #E7060A;"></span></td>
						</tr>
						<tr height="30">
							<td align="right"><label for="email">电子邮箱：</label></td>
							<td align="left"><input name="email" id="email"
								maxlength="30" onBlur="emailCheck()" /> <span id="emailSpan"></span></td>
						</tr>
						<tr height="30">
							<td align="right">图形验证码：</td>
							<td align="left" valign="middle"><input type="text"
								name="checkCode" id="checkCode"><img id="checkImg"
								src="/news/servlet/ImageCheckCodeServlet?rand=-1" /></td>
						</tr>
						<tr height="30">
							<td></td>
							<td><input name="button" id="button" type="button"
								value="      注     册     " /></td>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
	</div>
</body>
</html>

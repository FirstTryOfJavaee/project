<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<link href="/news/css/1.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	var canSubmit = true; //全局变量
	function valName() {
		var pattern = new RegExp("^[a-z]([a-z0-9])*[-_]?([a-z0-9]+)$", "i"); //创建模式对象
		var str1 = $("#username").val(); //获取文本框的内容

		if ($("#username").val() == null || $("#username").val() == "") {
			document.getElementById("namespan").innerHTML = "*不能为空";
			return false;
		} else
			return true;
	}

	function valPassword() {
		var str = document.getElementById("password").value;
		if (document.getElementById("password").value == null || document.getElementById("password").value == "") {
			document.getElementById("passwordspan").innerHTML = "*不能为空";
			return false;
		} else
			return true;
	}

	function submit1() {
		result1 = valName();
		result1 = valPassword() && result1;
		if (result1)
			return true; //提交
		else
			return false; //阻止提交
	}
	var canSubmit = true; //全局变量

	//id:需验证的标签id，messageId显示验证信息的标签的id，patternString：验证模式，rightMessage：验证通过需显示的信息，errorMessage：验证失败需显示的信息
	function check(id, patternString, messageId, rightMessage, errorMessage) {
		var pattern = new RegExp(patternString, "i"); //创建模式对象
		var str1 = $("#" + id).val(); //获取文本框的内容

		if (str1.length >= 3 && pattern.test(str1)) { //pattern.test() 模式如果匹配，会返回true，不匹配返回false
			$("#" + messageId).html(rightMessage); //设置id为userNameSpan的标签的内部内容为 ok
			return true;
		} else {
			$("#" + messageId).html(errorMessage);
			canSubmit = false;
			return false;
		}
	}

	function userNameCheck() {
		var pattern = new RegExp("^[a-z]([a-z0-9])*[-_]?([a-z0-9]+)$", "i"); //创建模式对象
		var str1 = $("#userName").val(); //获取文本框的内容

		if (str1.length >= 3 && pattern.test(str1)) { //pattern.test() 模式如果匹配，会返回true，不匹配返回false
			$("#userNameSpan").html("ok"); //设置id为userNameSpan的标签的内部内容为 ok
			return true;
		} else {
			$("#userNameSpan").html("*用户名至少需要3个字符，必须以字母开头，以字母或数字结尾，可以有-和_");
			canSubmit = false;
			return false;
		}
	}

	function passwordCheck() {
		var pattern = new RegExp("^[a-z]([a-z0-9])*[-_]?([a-z0-9]+)$", "i"); //创建模式对象
		var str1 = $("#password").val(); //获取文本框的内容

		if (str1.length >= 8 && pattern.test(str1)) { //pattern.test() 模式如果匹配，会返回true，不匹配返回false
			$("#passwordSpan").html("ok");
			return true;
		} else {
			$("#passwordSpan").html("*密码至少需要8个字符，必须以字母开头，以字母或数字结尾，可以有-和_");
			canSubmit = false;
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


	$(document).ready(function() { //资源加载后才执行的 代码，就放到这个函数中，jquery能保证网页所有资源（html代码，图片，js文件，css文件等）都加载后，才执行此函数
		$("#checkImg").click(function() { //为id是checkImg的标签绑定  鼠标单击事件  的处理函数
			//$(selector).attr(attribute,value)  设置被选元素的属性值
			//网址后加如一个随机值rand，表示了不同的网址，防止缓存导致的图片内容不变
			$("#checkImg").attr("src", "/news/servlet/ImageCheckCodeServlet?rand=" + Math.random());
		});

		$("#button").click(function() {
			canSubmit = true;
			if ($("#checkCode").val() == "")
				alert("必须输入验证码！"); //
			else { //客户端数据验证通过
				$.ajax({ //验证码检测
					url : "/news/servlet/UserServlet?type1=login",
					type : "post",
					data : $("#form1").serialize(), //serialize():搜集表单元素数据，并形成查询字符串
					dataType : "json",
					cache : false,
					error : function(textStatus, errorThrown) { //ajax请求失败时，将会执行此回调函数
						alert("系统ajax交互错误: " + textStatus);
					},
					success : function(data, textStatus) { //ajax请求成功时，会执行此回调函数
						if (data.result == 1) {
							var newHtml = "登录成功！<br/>" +
								"<a href='/news/index.jsp'>返回前端主页</a>";
							$("#myDiv").html(newHtml);
						} else if (data.result == -3) { //服务器端验证图片验证码不存在
							alert("验证码不存在！请点击验证码生成新的验证码");
							$("#checkCode").val(""); //清空文本框
						} else if (data.result == -4) { //验证码错误
							alert("验证码错误，请重新输入验证码！");
							$("#checkCode").val("");
						} else if (data.result == 0) {
							alert("用户存在，但已被停用，请联系管理员！");
						} else if (data.result == -1) {
							alert("用户不存在，或者密码错误，请重新登录！");
						} else if (data.result == -2) {
							alert("出现其它错误，请重新登录！");
						}
					}
				});
			}
		});
	});
</script>
</head>

<body>
	<div id="myDiv"
		style="margin-left:auto;margin-right:auto;width:800px;margin-top:50px;">
		<div>
			<p>账户名有admin，eeeeeeeeee，aaaaaaaa，密码都为yang526163</p>
		</div>
		<form id="form1" name="form1"
			action="/news/servlet/UserServlet?type1=login" method="post"
			onsubmit="return submit1()">
			<div class="center" style="width:500px;margin-top:40px">
				<table height="121" border="0" align="center">
					<tbody>
						<tr height="30">
							<td></td>
							<td>登录</td>
						</tr>
						<tr height="30">
							<td align="right">用户名：</td>
							<td align="left"><input type="text" name="name" id="name"
								onBlur="valName()"><span id="namespan"></span></td>
						</tr>
						<tr height="30">
							<td align="right">密码：</td>
							<td align="left"><input type="password" name="password"
								id="password" onBlur="valPassword()"><span
								id="passwordspan"></span></td>
						</tr>
						<tr>
							<td align="right">图形验证码：</td>
							<td valign="middle"><input style="line-height:45px;"
								type="text" name="checkCode" id="checkCode"><img
								id="checkImg" style="margin-left:10px;float:right;"
								src="/news/servlet/ImageCheckCodeServlet?rand=-1" /></td>
						</tr>
						<tr height="30">
							<td></td>
							<td><input name="button" id="button" type="button"
								value="    登  录    " />	<a href="/news/user/free/findPassword.jsp">找回密码</a></td>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
	</div>
</body>
</html>

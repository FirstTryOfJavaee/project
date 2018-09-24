<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>注册</title>
<meta name="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">

<script type="text/javascript" src="/news/js/jquery/jquery-2.1.4.min.js"></script>
</td>

<style type="text/css">
.loginTable {
	padding: 0px;
	border: thin solid #39C;
	margin: 5px;
}

td {
	padding: 2px;
	border: 1px solid #39C;
	margin: 0px;
}

.span1 {
	color: #F00;
	margin-right: 20px;
}
</style>

<script type="text/javascript">
	var type = "email";
	//验证
	function check() {
		var pattern;
		if (type == "email")
			pattern = new RegExp("^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$", "i"); //创建模式对象
		else
			pattern = new RegExp("^1[3|4|5|8][0-9]\d{4,8}$", "i"); //创建模式对象

		var str1 = $("#email").val(); //获取文本框的内容

		if (pattern.test(str1)) { //pattern.test() 模式如果匹配，会返回true，不匹配返回false
			$("#content1Span").html("ok"); //设置id为userNameSpan的标签的内部内容为 ok
			return true;
		} else {
			if (type == "email")
				$("#content1Span").html("email格式不正确！");
			else
				$("#content1Span").html("手机号码格式不正确！");

			return false;
		}
	}


	$(document).ready(function() { //资源加载后才执行的 代码，就放到这个函数中，jquery能保证网页所有资源（html代码，图片，js文件，css文件等）都加载后，才执行此函数

		$("#byEmail").click(function() {
			type = "email";
		});

		$("#byTelephone").click(function() { //为id是userName的标签绑定  失去焦点事件  的处理函数
			type = "telephone";
		});

		$("#email").blur(function() { //为id是userName的标签绑定  失去焦点事件  的处理函数
			check();
		});

		$("#button").click(function() {
			if (!check())
				alert("输入格式错误！"); //阻止提交
			else if ($(type =="#checkCode").val() == "")
				alert("必须输入验证码！"); //
			else { //客户端数据验证通过
				if (type == "email") {
					$.ajax({ //验证码检测
						url : "/news/servlet/UserServlet?type1=byEmail",
						type : "post",
						data : $("#form1").serialize(), //serialize():搜集表单元素数据，并形成查询字符串
						dataType : "json",
						cache : false,
						error : function(textStatus, errorThrown) { //ajax请求失败时，将会执行此回调函数
							alert("系统ajax交互错误: " + textStatus);
						},
						success : function(data, textStatus) { //ajax请求成功时，会执行此回调函数
							if (data.result == -1) { //-1发送邮件失败
								alert("发送邮件失败！");
							} else if (data.result == -2) { //-2邮箱未注册过
								alert("邮箱未注册过！");
							} else if (data.result == 1) { //发送邮件成功
								alert("请登录邮箱查看邮件，按邮件提示操作找回密码！");
							}
						}
					});
				}
			}
		});
	});
</script>



</head>

<body>
	<div id="myDiv" style="width:900px;margin-left:auto;margin-right:auto;">
		<form id="form1" name="form1">
			<table width="900" border="0" align="center" cellpadding="0"
				cellspacing="0" class="loginTable">
				<tr>
					<td colspan="2" align="center">找回密码</td>
				</tr>
				<tr>
					<td align="right">找回密码方式：</td>
					<td><input name="radio" type="radio" id="byEmail"
						value="byEmail" checked> <label for="byEmail">电子邮箱</label>
						<span class="span1" id="emailSpan"></span>
				</tr>
				<tr>
					<td align="right"><label for="email">电子邮箱：</label></td>
					<td><input name="email" type="text" id="email" accesskey="p"
						tabindex="2" size="30" maxlength="30" onBlur="check()" /> <span
						class="span1" id="content1Span"></span></td>
				</tr>
				<tr>
					<td colspan="2" align="center"><input type="button"
						name="button" id="button" value="找回密码" /></td>
				</tr>
			</table>
		</form>
	</div>
	<br>
	<br>
</body>
</html>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>   
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>设置新密码</title>
    <meta name="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	
	<script type="text/javascript" src="/checkcodeEncryptionEmail/js/jquery/jquery-2.1.4.min.js"></script></td>
	
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
		var type="email";
		
		function passwordCheck(){
			var pattern = new RegExp("^[a-z]([a-z0-9])*[-_]?([a-z0-9]+)$","i");//创建模式对象
			var str1=$("#password").val();//获取文本框的内容
			
			if(str1.length>=8 && pattern.test(str1)){//pattern.test() 模式如果匹配，会返回true，不匹配返回false
				$("#passwordSpan").html("ok");
				return true;
			}else{
				$("#passwordSpan").html("*密码至少需要8个字符，必须以字母开头，以字母或数字结尾，可以有-和_");
				return false;
			}
		}
		
		function password1Check(){
			var pattern = new RegExp("^[a-z]([a-z0-9])*[-_]?([a-z0-9]+)$","i");//创建模式对象
			var str1=$("#password1").val();//获取文本框的内容
			var str2=$("#password").val();
			if(str1.length>=8 && pattern.test(str1)){//pattern.test() 模式如果匹配，会返回true，不匹配返回false
				if(str2.length>0 && str1==str2){//检测两个密码是否一致
					$("#password1Span").html("ok");
					return true;
				}else{
					$("#password1Span").html("密码不一致，请重新输入");
					$("#password1").val("");
					return false;
				}				
			}else{
				$("#password1Span").html("*密码至少需要8个字符，必须以字母开头，以字母或数字结尾，可以有-和_");
				return false;
			}
		}		
		
	
		$(document).ready(function() {//资源加载后才执行的 代码，就放到这个函数中，jquery能保证网页所有资源（html代码，图片，js文件，css文件等）都加载后，才执行此函数
			
			$("#button").click( function() {
				
			});
			
			$("#password").blur(function(){//为id是userName的标签绑定  失去焦点事件  的处理函数
				passwordCheck();
  			});
			
			$("#password1").blur(function(){//为id是userName的标签绑定  失去焦点事件  的处理函数
				password1Check();
  			});				
			
	       $("#button").click( function() {
	    	    if(!password1Check() )
	    	    	alert("输入有错误！");//阻止提交
	    	    else if(!password1Check())
	    	    	alert("输入有错误！");//
	    	    else{//客户端数据验证通过
					$.ajax({//验证码检测
						url : "/checkcodeEncryptionEmail/servlet/SecurityServlet?type=newPassword",
						type: "post", 
						data : $("#form1").serialize(),//serialize():搜集表单元素数据，并形成查询字符串
						dataType : "json",
						cache : false,
						error : function(textStatus, errorThrown) {//ajax请求失败时，将会执行此回调函数
							alert("系统ajax交互错误: " + textStatus);
						},
						success : function(data, textStatus) {//ajax请求成功时，会执行此回调函数
							if(data.result==1){//修改密码成功
								var newHtml="修改密码成功！<br/>"+
											"<a href='login.jsp'>登录</a><br/>"+
											"<a href='/checkcodeEncryptionEmail/index.jsp'>返回前端主页</a>";
								$("#myDiv").html(newHtml);
							}else if(data.result==-1){//修改密码失败
								alert("修改密码失！");
							}else if(data.result==-2){
								alert("修改密码超时！");		
								location.href="findPassword.jsp";	
							}else if(data.result==-3){//随机数错误
								alert("无权限修改密码！");
							}
						}
					});	
				}					
	       });
		});
		
		
	</script>	
	
  </head>
  
  <body>
  	<div id="myDiv">
	 	<form id="form1" name="form1" method="post" action="/checkcodeEncryptionEmail/servlet/SecurityServlet?type=register">
		  <table width="900" border="0" align="center" cellpadding="0" cellspacing="0" class="loginTable">
		    <tr>
		      <td colspan="2" align="center">输入新密码</td></tr>
		    <tr>
		      <td align="right">新密码：</td>
		      <td>
	          <input type="password" name="password" id="password" size="25" maxlength="15" onBlur="check()">
              <span class="span1" id="passwordSpan"></span></td>
		    </tr>	            
		    <tr>
		      <td align="right">重复一遍新密码：</td>
		      <td>
		      	<input name="password1" type="password" id="password1" size="25" maxlength="15" onBlur="check()"/>
		        <span class="span1" id="password1Span"></span>
		      </td>
		    </tr>		    
		    <tr>
		      <td colspan="2" align="center"><input type="button" name="button" id="button" value="修改密码"/></td>
	        </tr>
	        
		  </table>
		  <input type="hidden" name="rand" id="rand" value="${param.rand}">
		</form>  
	 </div>
  </body>
</html>

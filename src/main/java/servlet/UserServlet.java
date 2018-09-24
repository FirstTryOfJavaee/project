package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import service.UserService;
import tools.Message;
import tools.PageInformation;
import tools.SearchTool;
import tools.Tool;
import bean.User;
import bean.Userinformation;

public class UserServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String type = request.getParameter("type1");
		UserService userService = new UserService();
		Message message = new Message();

		if (type.equals("register")) {
			User user = new User();
			user.setType(request.getParameter("type"));
			user.setName(request.getParameter("name"));
			user.setPassword(request.getParameter("password"));
			user.setEmail(request.getParameter("email"));
			if (user.getType().equals("user"))
				user.setEnable("use");
			else
				user.setEnable("stop");
			int result = 0;
			String checkCode = request.getParameter("checkCode");
			HttpSession session = request.getSession();
			String severCheckCode = (String) session.getAttribute("checkCode");// 获取session中的验证码
			if (severCheckCode == null) {// 服务器端验证图片验证码不存在
				result = -3;
			} else if (!severCheckCode.equals(checkCode)) {// 服务器端验证图片验证码验证失败
				result = -4;
			} else {// 验证码验证正确
				result = userService.register(user);// 注册用户
			}
			// 将result返回客户端的 ajax 请求
			Tool.returnIntResult(response, result);// 使用工具类的方法给ajax请求返回json格式的数据

		} else if (type.equals("login")) {
			User user = new User();
			user.setName(request.getParameter("name"));
			user.setPassword(request.getParameter("password"));
			// 加盐验证
			int result = userService.login(user);
			String checkCode = request.getParameter("checkCode");
			HttpSession session = request.getSession();
			String severCheckCode = (String) session.getAttribute("checkCode");// 获取session中的验证码
			if (severCheckCode == null) {// 服务器端验证图片验证码不存在
				result = -3;
			} else if (!severCheckCode.equals(checkCode)) {// 服务器端验证图片验证码验证失败
				result = -4;
			} else {// 验证码验证正确
				if (result == 1) {
					user.setPassword(null);// 防止密码泄露
					request.getSession().setAttribute("user", user);
				}
			}
			// 将result返回客户端的 ajax 请求
			Tool.returnIntResult(response, result);// 使用工具类的方法给ajax请求返回json格式的数
		} else if (type.equals("exit")) {
			request.getSession().removeAttribute("user");
			response.sendRedirect("/news/index.jsp");
		} else if (type.equals("showPage")) {
			PageInformation pageInformation = new PageInformation();
			Tool.getPageInformation("user", request, pageInformation);
			List<User> users = userService.getOnePage(pageInformation);
			request.setAttribute("pageInformation", pageInformation);
			request.setAttribute("users", users);
			getServletContext().getRequestDispatcher("/manager/userShow.jsp").forward(request, response);
		} else if (type.equals("search")) {
			PageInformation pageInformation = new PageInformation();
			Tool.getPageInformation("user", request, pageInformation);
			pageInformation.setSearchSql(SearchTool.user(request));
			List<User> users = userService.getOnePage(pageInformation);
			request.setAttribute("pageInformation", pageInformation);
			request.setAttribute("users", users);
			getServletContext().getRequestDispatcher("/manager/userShow.jsp").forward(request, response);
		} else if (type.equals("check")) {
			PageInformation pageInformation = new PageInformation();
			Tool.getPageInformation("user", request, pageInformation);
			String id = pageInformation.getIds();
			pageInformation.setIds(null);
			List<User> users = userService.check(pageInformation, id);
			if (users == null) {
				message.setMessage("切换可用性失败，请联系管理员！");
				message.setRedirectUrl("/news/servlet/UserServlet?type1=check&page=1&pageSize=2");
			} else {
				request.setAttribute("pageInformation", pageInformation);
				request.setAttribute("users", users);
				getServletContext().getRequestDispatcher("/manager/userCheck.jsp").forward(request, response);
			}
		} else if (type.equals("delete")) {
			PageInformation pageInformation = new PageInformation();
			Tool.getPageInformation("user", request, pageInformation);
			pageInformation.setSearchSql(" (type='user' or type='newsAuthor')");
			List<User> users = userService.deletes(pageInformation);
			request.setAttribute("pageInformation", pageInformation);
			request.setAttribute("users", users);
			getServletContext().getRequestDispatcher("/manager/userDelete.jsp").forward(request, response);
		} else if (type.equals("changePassword")) {
			String newPassword = request.getParameter("newPassword");
			User user = (User) request.getSession().getAttribute("user");
			user.setPassword(request.getParameter("oldPassword"));
			Integer result = userService.changePassword(user, newPassword);
			message.setResult(result);
			if (result == 1) {
				message.setMessage("修改密码成功！");
			} else if (result == 0) {
				message.setMessage("修改密码失败，请联系管理员！");
			}
			message.setRedirectTime(1000);
			request.setAttribute("message", message);
			getServletContext().getRequestDispatcher("/message.jsp").forward(request, response);
		} else if (type.equals("showPrivate")) {// 显示普通用户个人信息
			User user = (User) request.getSession().getAttribute("user");
			if ("user".equals(user.getType())) {
				Userinformation userinformation = userService.getByUserId(user.getUserId());
				request.setAttribute("userinformation", userinformation);
			}
			getServletContext().getRequestDispatcher("/user/manage/showPrivate.jsp").forward(request, response);
		} else if (type.equals("changePrivate1")) {// 修改普通用户个人信息的第一步：显示可修改信息
			User user = (User) request.getSession().getAttribute("user");
			if ("user".equals(user.getType())) {
				Userinformation userinformation = userService.getByUserId(user.getUserId());
				request.setAttribute("userinformation", userinformation);
			}
			getServletContext().getRequestDispatcher("/user/manage/changePrivate.jsp").forward(request, response);
		} else if (type.equals("changePrivate2")) {// 修改普通用户个人信息的第二步：修改信息
			User user = (User) request.getSession().getAttribute("user");
			if ("user".equals(user.getType())) {
				Userinformation userinformation = new Userinformation();
				userinformation.setUserId(user.getUserId());
				userinformation.setSex(request.getParameter("sex"));
				userinformation.setHobby(request.getParameter("hobby"));
			}
			Integer result = userService.updatePrivate(user, request);
			message.setResult(result);
			if (result == 5) {
				message.setMessage("修改个人信息成功！");
				message.setRedirectUrl("/news/servlet/UserServlet?type1=showPrivate");
			} else if (result == 0) {
				message.setMessage("修改个人信息失败，请联系管理员！");
				message.setRedirectUrl("/news/servlet/UserServlet?type1=showPrivate");
			}
			request.setAttribute("message", message);
			getServletContext().getRequestDispatcher("/message.jsp").forward(request, response);
		} else if (type.equals("byEmail")) {// 找回密码
			User user = new User();
			user.setEmail(request.getParameter("email"));
			int result = 0;
			Integer rand = Tool.getRandomInRangeInteger(10, 100000);// 随机数作为验证修改密码用
			try {
				result = userService.findPasswordByEmail(user, rand);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if (result == 1) {// 发送邮件成功
				HttpSession session = request.getSession();
				session.setAttribute("email", user.getEmail());
				session.setAttribute("rand", rand);
				session.setAttribute("time", new Date());
			}
			Tool.returnIntResult(response, result);
		}
	}
}

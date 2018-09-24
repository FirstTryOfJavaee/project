package dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import tools.Encryption;
import tools.PageInformation;
import tools.Tool;
import tools.WebProperties;
import bean.User;

public class UserDao {
	public boolean hasUser(User user, DatabaseDao databaseDao) throws SQLException {
		String sql = "select * from user where name='" + user.getName() + "'";
		databaseDao.query(sql);
		while (databaseDao.next()) {
			return true;
		}
		return false;
	}

	public Integer register(User user, DatabaseDao databaseDao) throws SQLException {
		user.setHeadIconUrl("\\" + WebProperties.config.getString("projectName")
				+ WebProperties.config.getString("headIconFileDefault"));// 默认头像
		// 根据密码生成盐和加密密码
		Encryption.encryptPasswd(user);
		String sql = "insert into user(type,name,password,enable,email,salt,headIconUrl) values('" + user.getType()
				+ "','" + user.getName() + "','" + user.getPassword() + "','" + user.getEnable() + "','"
				+ user.getEmail() + "','" + user.getSalt() + "','" + user.getHeadIconUrl().replace("\\", "/") + "')";
		return databaseDao.update(sql);
	}

	public Integer login(User user) throws SQLException, Exception {
		User user1 = new User();
		DatabaseDao databaseDao = new DatabaseDao();
		String sql = "select * from user where name='" + user.getName() + "'";
		databaseDao.query(sql);
		while (databaseDao.next()) {
			String enable = databaseDao.getString("enable");
			if (("use").equals(enable)) {
				user1.setName(databaseDao.getString("name"));
				user1.setPassword(databaseDao.getString("password"));
				user1.setType(databaseDao.getString("type"));
				user1.setUserId(databaseDao.getInt("userId"));
				user1.setHeadIconUrl(databaseDao.getString("headIconUrl"));
				user1.setSalt(databaseDao.getString("salt"));
				user1.setEmail(databaseDao.getString("email"));
				user1.setRegisterDate(databaseDao.getTimestamp("registerDate"));
				user.setSalt(user1.getSalt());
				// 检查密码是否正确
				if (Encryption.checkPassword(user, user1.getPassword())) {
					user = user1;
					return 1;
				} else
					return -1;
			}
			return 0;// 用户存在，但被停用
		}
		return -1;// 该用户不存在或密码错误
	}

	public List<User> getOnePage(PageInformation pageInformation, DatabaseDao databaseDao) throws SQLException {
		List<User> users = new ArrayList<User>();
		String sqlCount = Tool.getSql(pageInformation, "count");
		Integer allRecordCount = databaseDao.getCount(sqlCount);// 符合条件的总记录数
		Tool.setPageInformation(allRecordCount, pageInformation);// 更新pageInformation的总页数等

		String sqlSelect = Tool.getSql(pageInformation, "select");
		databaseDao.query(sqlSelect);
		while (databaseDao.next()) {
			User user = new User();
			user.setEnable(databaseDao.getString("enable"));
			user.setName(databaseDao.getString("name"));
			user.setRegisterDate(databaseDao.getTimestamp("registerDate"));
			user.setType(databaseDao.getString("type"));
			user.setUserId(databaseDao.getInt("userId"));
			users.add(user);
		}
		return users;
	}

	// 切换用户的可用性
	public Integer changeEnable(String id, DatabaseDao databaseDao) throws SQLException {// 查询失败返回-1
		String sql = "select * from user where userId in (" + id + ")";
		databaseDao.query(sql);
		while (databaseDao.next()) {
			String enable = databaseDao.getString("enable");
			if ("use".equals(enable))
				enable = "stop";
			else
				enable = "use";
			sql = "update user set enable='" + enable + "' where userId in (" + id + ")";
			databaseDao.update(sql);
			return 1;
		}
		return 0;
	}

	// 删除多个用户
	public Integer deletes(String ids, DatabaseDao databaseDao) throws SQLException {// 查询失败返回-1
		if (ids != null && ids.length() > 0) {
			String sql = "delete from user where userId in (" + ids + ")";
			return databaseDao.update(sql);
		} else
			return -1;
	}

	public Integer updateHeadIcon(User user, DatabaseDao databaseDao) throws SQLException {//
		String sql = "update user set headIconUrl='" + user.getHeadIconUrl() + "' where userId ="
				+ user.getUserId().toString();
		return databaseDao.update(sql.replace("\\", "/"));

	}

	// 根据字段名，查是否有字段值为value的记录
	public int hasStringValue(String fieldName, String value) throws Exception {// 返回值：1表示有相同值、-1表示没有相同值
		int result = -1;
		DatabaseDao databaseDao = new DatabaseDao();
		databaseDao.query("select * from user where " + fieldName + "='" + value + "'");
		while (databaseDao.next()) {
			result = 1;
		}
		return result;
	}
}

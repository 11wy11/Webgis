package com.wyjava.bean;


import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginServlet extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public LoginServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("login");
		String username = request.getParameter("username");     
        String password = request.getParameter("password");
        String authCode = request.getParameter("authCode");
        
        authCode =URLDecoder.decode(authCode,"UTF-8"); 
        authCode =URLDecoder.decode(authCode,"UTF-8");
        username =URLDecoder.decode(username,"UTF-8"); 
        username =URLDecoder.decode(username,"UTF-8");
        password =URLDecoder.decode(password,"UTF-8");
        password =URLDecoder.decode(password,"UTF-8");
        String code = (String) request.getSession().getAttribute("authCode"); 
        //服务器端打印信息  
        System.out.println("username=" + username);  
        System.out.println("password=" + password);
        System.out.println("authCode=" + authCode);
        System.out.println("code=" + code);
        //设置编码格式  
        response.setContentType("text/html;charset=UTF-8");  
        PrintWriter out = response.getWriter();
        //验证输入验证码是否正确
        if (authCode != null && authCode.toUpperCase().equals(code)) {      
	        //返回html页面
	        ManageUser manageUser =new ManageUser();
	        System.out.println("验证码正确");
	        List<User> list = manageUser.getAll(); 
	        for(User u: list){ 
	        if(u.getUsername().equals(username) && u.getPassword().equals(password)){ 
	        request.getSession().setAttribute("user", u);//登录成功，将用户数据放入到Session中 
	        out.println(2);
	        //response.sendRedirect("../mainindex.jsp"); 
	        return;//进行重定向，并且下面的代码不再执行 
	        } 
	        } 
	        out.println("<html>"); 
	        out.println("<head>");     
		    out.println("<title>登录信息</title>");      
		    out.println("</head>");    
		    out.println("<body>");     
		    out.println("提示：用户名或密码错误");    
		    out.println("</body>");    
		    out.println("</html>");
	       
	        }
        //验证码错误
        else{  
        	out.println("验证码错误!");
        }
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request,response);
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}

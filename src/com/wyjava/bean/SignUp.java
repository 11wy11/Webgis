package com.wyjava.bean;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class SignUp
 */
@WebServlet("/SignUp")
public class SignUp extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SignUp() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
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
	        String res=manageUser.logup(username, password);
	        System.out.println("注册结果："+res);
	        if(!res.equals("0")){ 
	        	User u=new User(username,password);
	        request.getSession().setAttribute("user", u);//登录成功，将用户数据放入到Session中 
	        out.println(2);
	        //response.sendRedirect("../mainindex.jsp"); 
	        return;//进行重定向，并且下面的代码不再执行  
	        } 
	        out.println("<html>"); 
	        out.println("<head>");     
		    out.println("<title>注册信息</title>");      
		    out.println("</head>");    
		    out.println("<body>");     
		    out.println("提示：注册失败");    
		    out.println("</body>");    
		    out.println("</html>");
	       
	        }
        //验证码错误
        else{  
        	out.println("验证码错误!");
        }
       
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}

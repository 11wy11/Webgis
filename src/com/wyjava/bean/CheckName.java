package com.wyjava.bean;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CheckName extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Constructor of the object.
	 */
	public CheckName() {
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

		response.setCharacterEncoding("UTF-8");
		 
		//response.setContentType(arg0);
		//request.setCharacterEncoding("UTF-8");
		//response.setCharacterEncoding("UTF-8");
		//根据城市名称查地理信息
		/*String cityname=request.getParameter("name");
		cityname =URLDecoder.decode(cityname, "UTF-8");
		cityname =URLDecoder.decode(cityname, "UTF-8");
		System.out.println(cityname);
		DBConnect db=new DBConnect();
		String geojson=db.getName(cityname);
		System.out.println(geojson);
		PrintWriter out = response.getWriter();
		out.print(geojson);
		out.flush();
		out.close();*/
		//根据指定sql查询记录
		String sql=request.getParameter("sql");
		System.out.println("后端接收："+sql);
		DBConnect db=new DBConnect();
		String geojson=db.selectData(sql);
		System.out.println("查询结果："+geojson);
		PrintWriter out = response.getWriter();
		out.print(geojson);
		out.flush();
		out.close();
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

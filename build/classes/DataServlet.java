package com.wyjava.bean;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * 前后端交互
 * @author WeiYuan
 *
 */
public class DataServlet extends HttpServlet {
	/**
	 * 序列号
	 */
	private static final long serialVersionUID = 4940010298081250990L;

	/**
	 * Constructor of the object.
	 */
	public DataServlet() {
		super();
	}

	/**
	 * Destruction of the MyServlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the MyServlet. <br>
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
		
		
		
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");
		out.print("    This is ");
		out.print(this.getClass());
		out.println(", using the GET method");
		out.println("  </BODY>");
		out.println("</HTML>");

		out.flush();
		out.close();
	}

	/**
	 * The doPost method of the MyServlet. <br>
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
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String sname=request.getParameter("name");
		DBConnect db=new DBConnect();
		String geojson=db.getName(sname);
		/*response.setContentType("text/html");*/
		PrintWriter out = response.getWriter();
		String result="{'success':'true'},"+geojson;
		/*JSONObject jsonObj = new JSONObject(); 
	    JSONObject geoobj=new JSONObject(geojson);
		jsonObj.put("success", "成功");
		JSONArray array= new JSONArray();
		array.put(jsonObj);
		array.put(geoobj);
		out.print(array.toString());*/
		out.print(result);
		out.flush();
		out.close();
	}

	/**
	 * Initialization of the MyServlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
		
	}
	public void serchbyname(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException,JSONException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String sname=request.getParameter("name");
		DBConnect db=new DBConnect();
		String geojson=db.getName(sname);
		/*response.setContentType("text/html");*/
		PrintWriter out = response.getWriter();
		JSONObject jsonObj = new JSONObject(); 
	    JSONObject geoobj=new JSONObject(geojson);
		jsonObj.put("success", "成功");
		JSONArray array= new JSONArray();
		array.put(jsonObj);
		array.put(geoobj);
		out.print(array.toString());
		out.flush();
		out.close();
	}

}

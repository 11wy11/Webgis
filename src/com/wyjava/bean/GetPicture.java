package com.wyjava.bean;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GetPicture
 */
@WebServlet("/GetPicture")
public class GetPicture extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetPicture() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		
		String id=new String(request.getParameter("id").getBytes("ISO8859-1"),"UTF-8");
		System.out.println(id);
		DBConnect db=new DBConnect();
		db.init();
		byte[] buf=db.getPicbyte(id);
		if(buf==null){
	     response.getWriter().print("暂未上传图片");
		}
		else{
		System.out.println("数据库中获得的数据："+buf);
		response.setContentType("image/jpeg");
		ServletOutputStream outStream=response.getOutputStream();
		outStream.write(buf);
		outStream.close();
		}
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request,response);
	}

}

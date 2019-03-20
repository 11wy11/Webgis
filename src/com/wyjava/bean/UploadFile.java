package com.wyjava.bean;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class UploadFile extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7629921168467942972L;
	// 上传文件存储目录
    private static final String UPLOAD_DIRECTORY = "upload";
  
    // 上传配置
    private static final int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE      = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE   = 1024 * 1024 * 50; // 50MB
	/**
	 * Constructor of the object.
	 */
	public UploadFile() {
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
		doPost(request,response);
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
		System.out.println("post method");
		System.out.println("上传图片");
		response.setContentType("text/html;charset=UTF-8");
		DiskFileItemFactory factory = new DiskFileItemFactory();	
		ServletFileUpload upload=new ServletFileUpload(factory);
		upload.setSizeMax(1024*1024);   //限制文件大小
		upload.setHeaderEncoding("UTF-8");
		String cityname="";
		try{
			List<FileItem> list=upload.parseRequest(request);
			InputStream stream;
			System.out.println(list.size());
			if(list.size()>0);
			for (FileItem item: list) 
			{
				if (item.isFormField()) {   
					  String name = item.getFieldName();  
	                    cityname = item.getString("name"); 
	                    cityname=new String(cityname.getBytes("ISO8859-1"),"UTF-8");	             
		                 System.out.println(name);
		                 System.out.println(cityname);
		                 cityname=URLDecoder.decode(cityname,"UTF-8");
		                 System.out.println(cityname);
				} 
				if(!item.isFormField()){
				stream=item.getInputStream();
				System.out.println(stream);
				DBConnect.UpdateImage(cityname,stream);
				}
				}
		}
			catch (FileUploadException e) {
			
				e.printStackTrace();
				}
		catch (Exception e) {
			e.printStackTrace();
		}
		
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

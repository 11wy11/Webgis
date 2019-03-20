package com.wyjava.bean;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * Servlet implementation class UpdateInfo
 */
@WebServlet("/UpdateInfo")
public class UpdateInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateInfo() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("更新数据");
		response.setContentType("text/html;charset=UTF-8");
		DiskFileItemFactory factory = new DiskFileItemFactory();	
		ServletFileUpload upload=new ServletFileUpload(factory);
		Timestamp currentTime= new Timestamp(System.currentTimeMillis()); 
		upload.setHeaderEncoding("UTF-8");
		try{
			List<FileItem> list=upload.parseRequest(request);
			InputStream stream;
			System.out.println(list.size());
			String cityname="";
			if(list.size()>0);
			for (FileItem item: list) 
			{
				if (item.isFormField()) {     
	                   String count = item.getString("count");
	                   int num= Integer.parseInt(count);
	                   System.out.println(num);
	                   for(int i=0;i<num;i++)
	                   {	                	
	                	 cityname=new String(item.getString("name"+i).getBytes("ISO8859-1"),"UTF-8");
		                 String gid=new String(item.getString("gid"+i).getBytes("ISO8859-1"),"UTF-8");
		                 String updater=new String(item.getString("currentUser").getBytes("ISO8859-1"),"UTF-8");
		                 String pinyin=new String(item.getString("pinyin"+i).getBytes("ISO8859-1"),"UTF-8");
		                 String time=currentTime.toString();
	                     cityname=URLDecoder.decode(cityname,"UTF-8");
	                     updater=URLDecoder.decode(updater,"UTF-8");                     
	                     DBConnect d=new DBConnect();
	                     d.update(cityname, pinyin, gid, updater, time);     				
	                 }								
				} 
				if(!item.isFormField()){
					stream=item.getInputStream();
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

		
		
		/*DBConnect db=new DBConnect();
		db.init();
		db.update(name,pinyin, id, updater,time);*/
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request,response);
	}

}

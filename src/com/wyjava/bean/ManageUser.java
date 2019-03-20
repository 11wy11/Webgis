package com.wyjava.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ManageUser {
	public static void main(String[] args) {
		ManageUser m = new ManageUser();
		String result=m.logup("weiyuan", "weiyuan");
		System.out.println(result);
		
	}
	public static List<User> list = new ArrayList<User>(); 
	//获得全体注册用户信息
	public static List<User> getAll(){ 
		DBConnect d =new DBConnect();	
		Connection con=null;
		Statement state=null;
		 ResultSet resultSearch=null;
		try{
			con=d.link();
		state=con.createStatement();  
	    String sql = "select * from public.\"User\" ";        
	    System.out.println("sql:"+sql);  
	      
	    resultSearch = state.executeQuery(sql);  
	      
	    while(resultSearch.next()){  
	    	String name =resultSearch.getString("name");
	    	String password =resultSearch.getString("password"); 
	    	User user =new User();
	    	user.setUsername(name);
	    	user.setPassword(password);
	    	list.add(user);
	    }   
		}catch(Exception e){  
	    System.out.println(e.getMessage());  
	    e.printStackTrace();
		}finally{
			try {
				resultSearch.close();
				state.close();
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
				throw new RuntimeException(e);
			}
		}
        return list;  
    }
	
	
	
	//验证用户名密码
		public String check (String name,String password){
		DBConnect d =new DBConnect();	
		Connection con=null;
		Statement state=null;
		 ResultSet resultSearch=null;
		try{
			con=d.link();
		state=con.createStatement();  
	    String sql = "select * from public.\"User\" where name='"+name+"'and pass='"+password+"'";        
	    System.out.println("sql:"+sql);  
	      
	    resultSearch = state.executeQuery(sql);  
	      
	    if(resultSearch.next()){  
	        System.out.println("login seccess"); 
	        return "success";
	    }else{                
	        return "false";
	    }    
	    
		}catch(Exception e){  
	    System.out.println(e.getMessage());  
	    e.printStackTrace(); 
	     return "error";
		}finally{
			try {
				resultSearch.close();
				state.close();
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
				throw new RuntimeException(e);
			}
		}
		}
		
		//注册用户名和密码
		public String logup (String name,String password){
			DBConnect d =new DBConnect();	
			Connection con=null;
			 PreparedStatement pstmt=null;
			int i=0;
			try{
				con=d.link(); 
		    String sql = "INSERT INTO Public.\"User\" (name, password) VALUES (?,?) ";       
		    System.out.println("sql:"+sql); 
		    pstmt =(PreparedStatement) con.prepareStatement(sql);
		    pstmt.setString(1, name);
		    pstmt.setString(2, password);
		    i=pstmt.executeUpdate();
		    pstmt.close();
			con.close();    
		    if(i!=0){  
		        System.out.println("success"); 
		        return name;
		    }else{                
		        return "0";
		    }    
			}catch (SQLException e) {
				
				e.printStackTrace();
				return "error";
			}
					
				
	
			}
}

package com.shinhan.filter;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/login/check.go")
public class LoginCheckFilter extends HttpServlet {
	private static final long serialVersionUID = 1L;
      
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		int rst = 0;
		if (sid.equals("null")) {
			response.getWriter().print(rst);
		} else {
			rst = 1;
			response.getWriter().print(rst);
		}
	}
}
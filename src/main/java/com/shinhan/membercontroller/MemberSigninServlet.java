package com.shinhan.membercontroller;

import java.io.IOException;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shinhan.model.MemberService;

@WebServlet("/member/signin.do")
public class MemberSigninServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher rd;
		rd = request.getRequestDispatcher("login.jsp");
		rd.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
		
		MemberService mservice = new MemberService();
		String id = request.getParameter("memberid");
		String pw = request.getParameter("memberpw");
		Boolean rst = mservice.login(id, pw);
		
		if (rst) {
			// 로그인 성공
			HttpSession session = request.getSession();
			session.setAttribute("sid", id);
			response.sendRedirect("../address/main.do");
		} else {
			request.setAttribute("message","로그인 실패");
			response.sendRedirect("../address/gosignin.go");
		}
	}

}

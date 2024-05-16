package com.shinhan.membercontroller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shinhan.dto.MemberDTO;
import com.shinhan.model.MemberService;

@WebServlet("/member/signup.go")
public class MemberSignupServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		String id = request.getParameter("memberid");
		String pw = request.getParameter("memberpwd");
		String name = request.getParameter("membername");
		
		MemberDTO member = new MemberDTO(id,pw,name,0);
		
		MemberService service = new MemberService();
		int result = service.joinMember(member);
		System.out.println(result + "회원가입 성공");
		
		/*
		 * request.setAttribute("message", result +"개 계정 생성"); RequestDispatcher rd; rd
		 * = request.getRequestDispatcher("../jsp/signin.jsp"); rd.forward(request,
		 * response);
		 */
		response.sendRedirect("../address/gosignin.go");
	}

}

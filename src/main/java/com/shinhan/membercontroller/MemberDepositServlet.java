package com.shinhan.membercontroller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shinhan.model.MemberService;

@WebServlet("/member/deposit.do")
public class MemberDepositServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		int money = Integer.parseInt(request.getParameter("money"));
		MemberService service = new MemberService();
		int result = service.deposit(money, sid);
		response.getWriter().print(result);
	}

}

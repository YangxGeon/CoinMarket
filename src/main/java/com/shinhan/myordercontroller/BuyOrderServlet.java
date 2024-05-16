package com.shinhan.myordercontroller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shinhan.model.OrderService;

@WebServlet("/order/buy.do")
public class BuyOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int inputDataCheck= 0 ;
		
		int orderNum = Integer.parseInt(request.getParameter("orderNum"));
		String sid = request.getParameter("sid");
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		String name = request.getParameter("name");
		
		
		if (sid.equals("null") || name.equals("null") || orderNum == 0 || quantity == 0) {
			response.getWriter().print(inputDataCheck);
		} else {
			OrderService service = new OrderService();
			service.insertOrder(orderNum, sid, quantity, name);
			inputDataCheck = 1;
			response.getWriter().print(inputDataCheck);
		}
	}
}

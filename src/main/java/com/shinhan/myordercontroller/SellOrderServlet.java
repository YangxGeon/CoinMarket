package com.shinhan.myordercontroller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shinhan.model.OrderService;


@WebServlet("/order/sell.do")
public class SellOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int inputDataCheck= 0 ;
		
		String sid = request.getParameter("sid");
		String name = request.getParameter("name");
		int price = Integer.parseInt(request.getParameter("price"));
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		
		if (sid.equals("null") || name.equals("null") || price == 0 || quantity == 0) {
			response.getWriter().print(inputDataCheck);
		} else {
			OrderService service = new OrderService();
			service.insertSellOrderAndUpdateMyCoin(sid, name, quantity, price);
			inputDataCheck = 1;
			response.getWriter().print(inputDataCheck);
		}
	}
}

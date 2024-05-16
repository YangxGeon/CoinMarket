package com.shinhan.myordercontroller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.shinhan.dto.OrderDTO;
import com.shinhan.model.OrderService;

@WebServlet("/order/myorder.do")
public class MySellOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		List<OrderDTO> orderlist = new OrderService().MySellOrder(sid);
		
		Gson gson = new GsonBuilder().create();
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(gson.toJson(orderlist));
	}
}

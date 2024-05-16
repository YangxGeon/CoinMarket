package com.shinhan.mycoincontroller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shinhan.dto.CoinDTO;
import com.shinhan.model.CoinService;
import com.shinhan.model.MyCoinService;


@WebServlet("/mycoin/mycoin.do")
public class MyCoinServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		String coinname = request.getParameter("coin");
		int quantity = new MyCoinService().getMyCoinQuantity(sid, coinname);
		response.getWriter().print(quantity);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String encoding = "utf-8";
		req.setCharacterEncoding(encoding);
		String sid = req.getParameter("sid");
		String coinname = req.getParameter("coin");
		int quantity = new MyCoinService().getMyCoinQuantity(sid, coinname);
		
		CoinService service = new CoinService();
        List<CoinDTO> coinlist = service.CurrentCoin();
        
        String tmpPrice = "";
        
        for (CoinDTO coin : coinlist) {
            if (coinname.equals(coin.getCoin_name())) {
            	tmpPrice = String.valueOf(coin.getCoin_price());
                break;
            }
        }
		
        int coin_price = Integer.parseInt(tmpPrice);
        int result = quantity*coin_price;

        resp.setContentType("text/html;charset=utf-8");
		resp.getWriter().print(result);
        
	}

}

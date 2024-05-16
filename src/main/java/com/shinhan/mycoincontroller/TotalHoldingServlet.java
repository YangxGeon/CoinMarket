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
import com.shinhan.model.MemberService;
import com.shinhan.model.MyCoinService;

@WebServlet("/mycoin/mytotal.do")
public class TotalHoldingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String sid = request.getParameter("sid");
		
		MemberService mservice = new MemberService();
		int balance = mservice.balance(sid);
		
		int result = 0;
		String btc = "BTC";
		String eth = "ETH";
		String xrp = "XRP";
		String doge = "DOGE";
		int btcq = new MyCoinService().getMyCoinQuantity(sid, btc);
		int ethq = new MyCoinService().getMyCoinQuantity(sid, eth);
		int xrpq = new MyCoinService().getMyCoinQuantity(sid, xrp);
		int dogeq = new MyCoinService().getMyCoinQuantity(sid, doge);

		CoinService service = new CoinService();
		List<CoinDTO> coinlist = service.CurrentCoin();

		int btcp = 0;
		int ethp = 0;
		int xrpp = 0;
		int dogep = 0;

		for (CoinDTO coin : coinlist) {
			if (btc.equals(coin.getCoin_name())) {
				btcp = coin.getCoin_price();
				break;
			}
		}
		for (CoinDTO coin : coinlist) {
			if (eth.equals(coin.getCoin_name())) {
				ethp = coin.getCoin_price();
				break;
			}
		}
		for (CoinDTO coin : coinlist) {
			if (xrp.equals(coin.getCoin_name())) {
				xrpp = coin.getCoin_price();
				break;
			}
		}
		for (CoinDTO coin : coinlist) {
			if (doge.equals(coin.getCoin_name())) {
				dogep = coin.getCoin_price();
				break;
			}
		}

		result = balance + (btcq * btcp) + (ethq * ethp) + (xrpq * xrpp) + (dogeq * dogep);
		response.getWriter().print(result);
	}

}

package com.shinhan.coincontroller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shinhan.dto.CoinDTO;
import com.shinhan.model.CoinService;


@WebServlet("/coin/btcprice.do")
public class BtcSelectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CoinService service = new CoinService();
        List<CoinDTO> coinlist = service.CurrentCoin();
        
        String Value = "";
        
        for (CoinDTO coin : coinlist) {
            if ("BTC".equals(coin.getCoin_name())) {
                Value = String.valueOf(coin.getCoin_price());
                break;
            }
        }
        response.getWriter().print(Value);
    }
}




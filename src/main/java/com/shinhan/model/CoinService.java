package com.shinhan.model;

import java.util.List;

import com.shinhan.dto.CoinDTO;

public class CoinService {
	CoinDAO coinDAO = new CoinDAO();

	public List<CoinDTO> CurrentCoin() {
		return coinDAO.CurrentCoin();
	}
}

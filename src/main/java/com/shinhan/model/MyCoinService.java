package com.shinhan.model;

import java.util.List;

import com.shinhan.dto.MyCoinDTO;

public class MyCoinService {
	MyCoinDAO mycoinDAO = new MyCoinDAO();

	public List<MyCoinDTO> getMyCoins(String session) {
		return mycoinDAO.getMyCoins(session);
	}
	
	public int getMyCoinQuantity(String session, String coinName) {
		return mycoinDAO.getMyCoinQuantity(session, coinName);
	}
}

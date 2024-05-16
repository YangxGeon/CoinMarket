package com.shinhan.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CoinDTO {
	private String coin_name;
	private int coin_price; // 코인 최근 거래가
}

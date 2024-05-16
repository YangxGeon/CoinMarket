package com.shinhan.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MyCoinDTO {
	private String member_id;
	private String coin_name;
	private int my_quantity;
	private int purchase_price;
	private int current_price; // join 용
	private int total_value; // 총평가 용
	private int coin_price;
}

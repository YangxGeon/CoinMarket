package com.shinhan.dto;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class OrderDTO {
	private int order_num;
	private String member_id;
	private String order_type;
	private int order_quantity;
	private int order_price;
	private Date order_time;
	private String coin_name;

}

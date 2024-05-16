package com.shinhan.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {
	// 문자가 들어오면 문자를 util의 데이터로 return
	public static Date getUtilDate(String d) { // static으로 new안해도 사용가능하게
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date result = null;
		try {
			result = sdf.parse(d);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	public static java.sql.Date getSQLDate(String d) { // static으로 new안해도 사용가능하게
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");	 
		java.sql.Date result = null;
		try {
			Date d2 = sdf.parse(d);
			result = new java.sql.Date(d2.getTime());
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
}

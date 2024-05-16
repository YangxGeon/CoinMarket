package com.shinhan.model;

import com.shinhan.dto.MemberDTO;

public class MemberService {
	MemberDAO memberDAO = new MemberDAO();

	// 회원가입
	public int joinMember(MemberDTO mem) {
		return memberDAO.joinMember(mem);
	}

	// 로그인
	public Boolean login(String id, String pw) {
		return memberDAO.login(id, pw);
	}

	// KRW 입금
	public int deposit(int money, String session) {
		return memberDAO.deposit(money, session);
	}

	// KRW 출금
	public int withdraw(int money, String session) {
		return memberDAO.withdraw(money, session);
	}

	// KRW 조회
	public int balance(String session) {
		return memberDAO.balance(session);
	}
}

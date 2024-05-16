<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document"%>
<%@ page import="org.jsoup.nodes.Element"%>
<%@ page import="org.jsoup.select.Elements"%>
<%
try {
	// Jsoup을 사용하여 네이버 뉴스 페이지에서 비트코인 관련 뉴스를 크롤링
	Document doc = Jsoup.connect("https://search.naver.com/search.naver?where=news&query=비트코인").get();

	// 뉴스 제목과 링크를 추출하여 표시
	Elements newsElements = doc.select(".news_area");
	int newsCount = Math.min(newsElements.size(), 9);
	for (int i = 0; i < newsCount; i++) {
		Element element = newsElements.get(i);
		String title = element.select("a.news_tit").text();
		String link = element.select("a.news_tit").attr("href");
%>
<div class="col-sm-4">
	<div class="news-item">
		<h4><%=title%></h4>
		<p>
			<a href="<%=link%>">원문 보기</a>
		</p>
	</div>
</div>
<%
}
} catch (Exception e) {
e.printStackTrace();
}
%>

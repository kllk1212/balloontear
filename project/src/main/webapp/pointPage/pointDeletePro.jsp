<%@page import="project.pointPage.model.ShopBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title> 
</head>
<%	
	int sNo = Integer.parseInt(request.getParameter("sNo"));
	
	ShopBoardDAO shopboarddao = new ShopBoardDAO();
	shopboarddao.delete(sNo); 
	
	response.sendRedirect("/project/pointPage/pointShop.jsp"); 
%>
</body>
</html>
<%@page import="project.adminMyPage.model.AdminDateDAO"%>
<%@page import="project.memMyPage.model.MemDataDTO"%>
<%@page import="project.memMyPage.model.MemDataDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="project.signup.model.MemberSignupDTO"%>
<%@page import="project.volPage.model.VolBoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="project.volPage.model.VolBoardDAO"%>
<%@page import="project.signup.model.MemberSignupDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>adminMyPage</title>
	<%-- 파비콘 --%>
	<link rel="shortcut icon" href="/project/save/favicon.ico" type="image/x-icon"> 
	<%-- 부트스트랩 --%>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">
	<link href="/docs/5.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">
	
	<link rel="stylesheet" href="/project/css/adminMypageStyle.css" type="text/css">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Comfortaa&family=Gowun+Dodum&family=IBM+Plex+Sans+KR:wght@300&display=swap" rel="stylesheet">
	
	<style>
	.container{
	padding-right: 20px;
	padding-bottom: 20px;
	padding-left: 20px;
	}
	
	
	</style>

</head>
	<%
	   String id = (String)session.getAttribute("memId");
	   MemberSignupDAO signdao = new MemberSignupDAO();
	   
	   if(id== null || id.equals(null) || id.equals("null")) { %>
	   <script>
	   alert("로그인 후 이용해주세요")
	   window.location.href="/project/main/main.jsp";
	   </script>
	   <% }else { 
		   
		   
	  
	   
	   MemDataDAO memDataDAO = new MemDataDAO();
	   AdminDateDAO adDAO = new AdminDateDAO();
	   String category = "";
	   String userName = "";
	 //아이디 주고 카테고리 찾아오기 메서드 만들기
	 
	   MemberSignupDTO member = signdao.getMember(id); 
	 
		if(id != null){
		      category = signdao.categorySeach(id);
		      userName = signdao.getName(id);
		}else{
		   category = "null";
		}

	 // 페이징 처리    
	   String pageNum = request.getParameter("pageNum");
	   if(pageNum == null){ // pageNum 파라미터 안넘어오면, 1페이지 보여지게 
	      pageNum = "1";   // 1로 값 체우기 
	   }
	   System.out.println("pageNum : " + pageNum);
	   
	   int pageSize = 10;  // 현재 페이지에서 보여줄 글 목록의 수 
	   int currentPage = Integer.parseInt(pageNum); // pageNum을 int로 형변환 -> 숫자 연산 
	   int startRow = (currentPage - 1) * pageSize + 1; 
	   int endRow = currentPage * pageSize; 
		   

	   
	   int count = 0;
	   List<MemberSignupDTO> memberList = null;
	   
	   // 검색 여부 판단 + 상단 검색 여부
	   String sel = request.getParameter("sel");
	   String search = request.getParameter("search");
	   String topSel = "memStatus";
	   String topSelVal = request.getParameter("topSelVal");
	   
	   if(sel != null && search != null){  // 일반 검색일 때
		  	count = adDAO.getMemSearchCount(sel, search);
	 		System.out.println("하단 검색 회원수  : " + count);
	   		if(count > 0){
	   			memberList = adDAO.getMemberSearch(startRow, endRow, sel, search);
	   		}
		   
	   } else if(topSelVal != null){
		   count = adDAO.getMemStatusCount(topSel, topSelVal);
	 		System.out.println("회원 상태별 검색 회원수 : " + count);
		   if(count > 0){
			   memberList = adDAO.getMemberStatus(startRow, endRow, topSel, topSelVal);
		   }
		   
	   }else{
		   count = adDAO.getMemCount();
	   		System.out.println("전체 회원수 : " + count);
		   if(count > 0){
			   memberList = adDAO.getAllMember(startRow, endRow);
		   }
		   
	   }
	   
	   int number = count - (currentPage - 1) * pageSize; // 화면에 뿌려줄 글번호(bno아님)
	      SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm"); 
	%>
<body class="text-center">
 <% if (session.getAttribute("memId")==null){ %>
   <div align="right">
      <table>
         <tr>
            <td><button class="btn btn-outline-secondary btn-sm" onclick="window.location='/project/login/loginForm.jsp'">로그인</button></td>
            <td><button class="btn btn-outline-secondary btn-sm" onclick="window.location='/project/signup/signupForm.jsp'">회원가입</button></td>
         </tr>
      </table>
   </div>
   <%} else { %>
      <div align="right">
      <table>
         <tr>
         <td><%=id %>님 환영합니다</td>
            <td><button class="btn btn-outline-secondary btn-sm" onclick="window.location='/project/login/logoutPro.jsp'">로그아웃</button></td>
               <%if(category.equals("mem")){ %>
                   <td><button class="btn btn-outline-secondary btn-sm" onclick="window.location='/project/memMyPage/memberMypage.jsp'">마이페이지</button></td>
                  <%}else if(category.equals("cen")){ %>
                  <td><button class="btn btn-outline-secondary btn-sm" onclick="window.location='/project/cenMyPage/centerMypage.jsp'">마이페이지</button></td>  
                  <%}else{ %>
                  <td><button class="btn btn-outline-secondary btn-sm" onclick="window.location='/project/adminMyPage/adminMypage.jsp'">마이페이지</button></td>  
                  <%} %>
         </tr>
      </table>
   </div>
   <% } %>
	
		    <%--타이틀--%>
      <div class="container-fluid p-3 text-black text-center"> 
       <img src="/project/save/logo.png" width="100px" />
      <%if (session.getAttribute("memId")==null){ %>
            <a class="Atitle" href="/project/main/main.jsp"><h2 align="center" id="homeTitle">BALLOONTEER</h2></a>
      <% }else { %>
         <%if(category.equals("mem")){ %>
            <a class="Atitle" href="/project/main/memberMain.jsp"><h2 align="center" id="homeTitle">BALLOONTEER</h2></a>
         <% } else { %>
            <a class="Atitle" href="/project/main/main.jsp"><h2 align="center" id="homeTitle">BALLOONTEER</h2></a>
         <% } %>
      <% } %>
      </div>
    
	  <%--내비바 --%>
	   <ul class="nav justify-content-center">
	      <li class="nav-item">
	        <a class="nav-link active" aria-current="page" href="/project/volPage/volBoardMain.jsp"><b>봉사</b></a>
	      </li>
	      <li class="nav-item">
	        <a class="nav-link" href="/project/pointPage/pointShop.jsp"><b>포인트샵</b></a>
	      </li>
	      <li class="nav-item">
	        <a class="nav-link" href="/project/freeBoard/freeBoardMain.jsp"><b>자유게시판</b></a>
	      </li>
	      <li class="nav-item">
	        <a class="nav-link" href="/project/infoPage/homepageInfo.jsp"><b>소개</b></a>
	      </li>
	   </ul>


<%-- ********************************************************************************************************************** --%>	
<br />
	<div class ="container" justify-content-md-center"> 
	<main class="d-flex flex-nowrap" >
 	<% if(category.equals("mem")){  // 카테고리가 mem이면 개인회원 폼띄워주기 %>
  	<div class="b-example-divider b-example-vr"></div>
  	<div class="d-flex flex-column flex-shrink-0 p-3 bg-light" style="width: 250px;">
		<svg class="bi pe-none me-5" width="40" height="32"></svg>
		<span class="fs-4">MY PAGE</span>
       <div>
			<h3><%= member.getMemName() %></h3>
		</div>
    
    <hr>
    
    <ul class="nav nav-pills flex-column mb-auto">
      <li class="nav-item">
        <a href ="/project/memMyPage/memberMypage.jsp" class="nav-link-active" aria-current="page">
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          MY BOARD
        </a>
      </li>
      <li>
        <a href="/project/memMyPage/memberMyVolPage.jsp" class="nav-link link-dark" >
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          내 봉사 현황
        </a>
      </li>
      <li>
        <a href="/project/memMyPage/memberMyPointPage.jsp" class="nav-link link-dark">
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          포인트 이용 내역
        </a>
      </li>
      <li>
        <a href="/project/signup/userModifyForm.jsp" class="nav-link link-dark"> 
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          회원 정보 수정
        </a>
      </li>
    </ul>
    <hr>
    <div class="dropdown">
      <a href="#" class="d-flex align-items-center link-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
        <img src="/project/save/<%= member.getMemPhoto() %>" width="32" height="32" class="rounded-circle me-3">
        <strong><%= member.getMemName() %></strong>
      </a>
      <ul class="dropdown-menu text-small shadow">
        <li><a class="dropdown-item" href="/project/login/logoutPro.jsp">로그아웃</a></li>
      </ul>
    </div>
  </div>
  
  <%-- 센터일때 분기처리 --%>
 <% }else if(category.equals("cen")){ %>
    <div class="b-example-divider b-example-vr"></div>
  <div class="d-flex flex-column flex-shrink-0 p-3 bg-light" style="width: 280px;">
      <svg class="bi pe-none me-5" width="40" height="32"></svg>
      <span class="fs-4">MY PAGE</span>
      <div>
       <%=userName %>
	</div>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
      <li class="nav-item">
        <a href ="/project/cenMyPage/centerMypage.jsp" class="nav-link-active" aria-current="page">
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          봉사 모집 현황
        </a>
      </li>
      <li>
        <a href= "/project/signup/userModifyForm.jsp" class="nav-link link-dark" >
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          회원 정보 수정
        </a>
      </li>
      </ul>
    <hr>
    <div class="dropdown">
      <a href="#" class="d-flex align-items-center link-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
        <strong><%=userName %></strong>
      </a>
      <ul class="dropdown-menu text-small shadow">
		<li><a class="dropdown-item" href="/project/login/logoutPro.jsp">로그아웃</a></li>
      </ul>
    </div>
  </div>   
  
  <%--	admin일때 분기처리 --%>
   <% } else { %>
     <div class="b-example-divider b-example-vr"></div>
 	 <div class="d-flex flex-column flex-shrink-0 p-3 bg-light" style="width: 280px; border-radius: 16px";>
      <svg class="bi pe-none me-5" width="40" height="32"></svg>
      <span class="fs-4">MY PAGE</span>
       <div>
		<h3><%=userName %></h3>
	</div>
    </a>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
      <li class="nav-item">
        <a href="/project/adminMyPage/adminMypage.jsp"  class="nav-link active" aria-current="page">
          <svg class="bi pe-none mr-auto"  width="16" height="16"></svg>
          회원관리
        </a>
      </li>
      <li>
        <a href= "/project/adminMyPage/pointShopAdmin.jsp" class="nav-link link-dark">
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          포인트샵 관리
        </a>
      </li>
      <li>
        <a href= "/project/adminMyPage/buyMemberList.jsp" class="nav-link link-dark">
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          포인트샵 구매회원 관리
        </a>
      </li>
      <li>
        <a href="/project/adminMyPage/mainBanImgAdmin.jsp" class="nav-link link-dark">
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          메인 배너 관리
        </a>
      </li>
      <li>
        <a href="/project/adminMyPage/homepageAdmin.jsp" class="nav-link link-dark">
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          홈페이지 관리
        </a>
      </li>
      <li>
        <a href="/project/signup/userModifyForm.jsp" class="nav-link link-dark">
          <svg class="bi pe-none mr-auto" width="16" height="16"></svg>
          정보수정
        </a>
      </li>
    </ul>
    <hr>
    <div class="dropdown">
      <a href="#" class="d-flex align-items-center link-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
        <strong><%=userName %></strong>
      </a>
      <ul class="dropdown-menu text-small shadow">
		<li><a class="dropdown-item" href="/project/login/logoutPro.jsp">로그아웃</a></li>
      </ul>
    </div>
  </div>
  
  
 <% } %>
 
 
 <%--*********************************************************************************** --%>
 <div class="container">
		<div class="row">
	       <div class="col-sm">
			<h4 align="center"><b>회원관리</b></h4>
				<form action="adminMypage.jsp">
					<input class="btn btn-outline-secondary btn-sm" id="moreButton" type="submit" value="검색"/>
					<select name="topSelVal" id="moreButton">
						<option value=1>활동중 회원</option>
						<option value=0>활동 중지 회원</option>
					</select>
				</form>	
  			 <br />
  			 <hr />	
		        <% if(count == 0){ %>
	   			<table class="tableList">
					<tr>
						<td class="tableTd">No.</td>	  
						<td class="tableTd">ID</td>	 		
			   			<td class="tableTd">이름</td>	
						<td class="tableTd">연락처</td>	
						<td class="tableTd">주소</td>	
						<td class="tableTd">등급</td>	
						<td class="tableTd">포인트</td>
						<td class="tableTd">활동상태</td>
						<td class="tableTd">상태변경</td>
					</tr>	
					<tr>
						<td>회원이 없습니다.</td>
					</tr>
	   			</table>
	   		<% } else { // 회원이 있으면 %>
  				<table class="tableList">
					<tr>
						<td class="tableTd">No.</td>	  
						<td class="tableTd">ID</td>	 		
			   			<td class="tableTd">이름</td>	
						<td class="tableTd">연락처</td>	
						<td class="tableTd">주소</td>	
						<td class="tableTd">등급</td>	
						<td class="tableTd">포인트</td>
						<td class="tableTd">활동상태</td>
						<td class="tableTd">상태변경</td>
					</tr>	
					<%-- 회원 목록 반복해서 뿌리기 	--%>
					<% 
						String memberId = "null"; 
						for(int i=0 ; i < memberList.size() ; i++){
							MemberSignupDTO memberDTO = memberList.get(i);
							String memid = memberDTO.getMemId();
							MemDataDTO memDataDTO = memDataDAO.getMemData(memid);
							
							System.out.println("회원 getMemId " + memid);
							System.out.println("회원수 " + count);
					%>
					<tr>
						<td class="tableTd"><%= number-- %></td>
						<td class="tableTd"><%= memberDTO.getMemId() %></td>
						<td class="tableTd"><%= memberDTO.getMemName() %></td>
						<td class="tableTd"><%= memberDTO.getMemTel() %></td>
						<td class="tableTd"><%= memberDTO.getMemAd() %></td>
						<td class="tableTd">Level<%= memDataDTO.getMemLevel() %></td>
						<td class="tableTd"><%= memDataDTO.getMemPoint() %>P</td>
							<% if(memberDTO.getMemStatus() == 1){ %>
								<td class="tableTd">활동중</td>
							<% } else {  %>
								<td class="tableTd">활동 중지</td>
						<% } %>
						
						<% if(memberDTO.getMemId().equals("admin")){  // 관리자 이면 %>
								<td class="tableTd"><button class="btn btn-outline-secondary btn-sm" disabled>관리자 계정</button></td>
						<% } else if(memberDTO.getMemStatus() == 1){ 
								System.out.println("memberDTO.getMemStatus() 진입");
								memberId = memberDTO.getMemId(); 
								pageNum = request.getParameter("pageNum");
								
								if(pageNum == null || pageNum.equals(null) || pageNum.equals("null")){
									pageNum = "1";
								} %>
								<td class="tableTd"><button class="btn btn-outline-secondary btn-sm" onclick="myConfirm('<%= memberId %>','<%= pageNum %>')">계정정지</button></td>
						
						<% }else { // 활동 중지 상태이면 // 8월 2일 수정
                              memberId = memberDTO.getMemId(); %>
                          	 <td><button class="btn btn-outline-secondary btn-sm"  onclick="myConfirm2('<%= memberId %>','<%= pageNum %>')">계정정지해제</button></td>
                    	 <% } %>
					</tr>
					<% } // for%>
	   		</table>
	   		
	   		<script>
				function myConfirm(memberId, pageNum) {
				                    
				var ok = confirm("해당 회원의 계정을 정지 시키겠습니까?")
					if(ok) location.href='memberStopPro.jsp?memberId='+memberId+'&pageNum='+pageNum;
				}
				  function myConfirm2(memberId, pageNum) {
                      
		               var ok = confirm("해당 회원의 계정을 복구하시겠습니까?")
		                  if(ok) location.href='comBackPro.jsp?memberId='+memberId+'&pageNum='+pageNum;
		               }
				
			</script>
	   		
	   		
	   		<% } // 회원이 있으면 %>
	   		
				<br />
				
				
			   <%-- 게시판 목록 페이지 번호 뷰어 --%>
			   <div align="center">
			   <% if(count > 0) { 
			         // 한페이지에 보여줄 번호의 개수 
			         int pageNumSize = 5; 
			         // 총 몇페이지 나오는지 계산 
			         int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			         // 현재 페이지에 띄울 첫번째 페이지 번호 
			         int startPage = ((currentPage - 1) / pageSize) * pageNumSize + 1; 
			         // 현재 페이지에 띄울 마지막 페이지번호  (startPage ~ endPage까지 번호 반복해서 뿌릴)
			         int endPage = startPage + pageNumSize - 1; 
			      if(endPage > pageCount) { endPage = pageCount; } // 마지막 페이지번호 조정 
			
			      if(startPage > pageNumSize) { 
			         if(sel != null && search != null) { %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage-1%>&sel=<%=sel%>&search=<%=search%>"> &lt; &nbsp; </a>
			        <% }else if(topSel != null && topSelVal != null){ %>   
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage-1%>&topSel=<%=topSel%>&topSelVal=<%=topSelVal%>"> &lt; &nbsp; </a>
			         <%}else{%>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage-1%>"> &lt; &nbsp; </a>
			         <%}
			      }
			      
			      for(int i = startPage; i <= endPage; i++) { 
			         if(sel != null && search != null) { %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>"> &nbsp; <%= i %> &nbsp; </a>
			      <% } else if(topSel != null && topSelVal != null){ %>   
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=i%>&topSel=<%=topSel%>&topSelVal=<%=topSelVal%>"> &nbsp; <%= i %> &nbsp; </a>
			         <%}else{ %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=i%>"> &nbsp; <%= i %> &nbsp; </a> 
			         <%} 
			      }
			      
			      if(endPage < pageCount) { 
			         if(sel != null && search != null) { %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage+pageNumSize%>&sel=<%=sel%>&search=<%=search%>"> &nbsp; &gt; </a>
			     <%  }else if(topSel != null && topSelVal != null){ %>   
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage+pageNumSize%>&topSel=<%=topSel%>&topSelVal=<%=topSelVal%>"> &nbsp; &gt; </a>
			      <%   }else{ %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage+pageNumSize%>"> &nbsp; &gt; </a>
			      <%	}
			     	 } 
			      } %>
			
			      <br /><br />
	   		
	   		<%-- 작성자/내용 검색 --%>
		<form action="adminMypage.jsp">
			<select name="sel">
				<option value="memId" selected>회원 ID</option>
				<option value="memName">회원 이름</option>
			</select>
			<input type="text" name="search" /> 
			<input class="btn btn-outline-secondary btn-sm" type="submit" value="검색" />
		</form>
		<br />
		
		<button class="btn btn-outline-secondary btn-sm" onclick="window.location='adminMypage.jsp'"> 전체 회원보기 </button>
		                    
			</div> <%-- 게시판 페이지 뷰어 --%>
		</div> <%-- 회원관리  --%>
   	</div> <%-- row  --%>
   </div>	<%-- 컨테이너 --%>
   </div>
   </main>
 
   <%-- 
<body> 


	<div align="right">
		<table>
			<tr>
			<td>세션아이디: <%=id %> 회원분류: <%=category %></td>
				<td><button onclick="window.location='/project/login/logoutPro.jsp'">로그아웃</button></td>
					<% if(category.equals("admin")){  // 관리자로 로그인했을시 %>
	            	<td><button onclick="window.location='/project/adminMyPage/adminMypage.jsp'">마이페이지</button></td>
	            	<% } else if(category.equals("cen")){ // 센터로 로그인 했을시 %>
	           		<td><button onclick="window.location='/project/cenMyPage/centerMypage.jsp'">마이페이지</button></td>
	           		<% }else { %>
	            	<td><button onclick="window.location='/project/memMyPage/memberMypage.jsp'">마이페이지</button></td>
            		<%} %>
			</tr>
		</table>
	</div>

	
	<h1 align="center"><a href="/project/main/main.jsp">BALLOONTEER</a></h1>

	<nav>
		<ul>
			<li><a href="/project/volPage/volBoardMain.jsp">봉사</a></li>
			<li><a href="/project/freeBoard/freeBoardMain.jsp">자유게시판</a></li>
			<li><a href="/project/pointPage/pointShop.jsp">포인트샵</a></li>
			<li><a href="/project/infoPage/homepageInfo.jsp">소개</a></li>
		</ul>
	</nav>
	
	<%-- ********************************************************************************************************************** 
	<div class="container">
		<div class="row">
	       <div class="col-sm">
			<aside>
				<h3>MyPage</h3>
				<ul>
					<li><%=userName %></li>
					<li><hr width="200px" align="left"/></li>
					<li><a href= "adminMypage.jsp">회원관리</a></li>
					<li><a href= "pointShopAdmin.jsp">포인트샵 관리</a></li>
					<li><a href= "buyMemberList.jsp">포인트샵 구매회원 관리</a></li>
					<li><a href= "mainBanImgAdmin.jsp"> 메인 배너 관리</a></li>
					<li><a href= "homepageAdmin.jsp"> 홈페이지 관리</a></li>
					<li><a href= "/project/signup/userModifyForm.jsp"> 정보수정</a></li>
				</ul>
			 </aside>
			</div>
			
			
			<div class="col-sm">
			<h2>회원관리</h2>
			
			<section>
				<form action="adminMypage.jsp">
					<select name="topSelVal">
						<option value=1>활동중 회원</option>
						<option value=0>활동 중지 회원</option>
					</select>
					<input type="submit" value="검색"/>
				</form>		
			</section>
			
			
		        <% if(count == 0){ %>
	   			<table>
					<tr>
						<td>No.</td>	  
						<td>ID</td>	 		
			   			<td>이름</td>	
						<td>연락처</td>	
						<td>주소</td>	
						<td>등급</td>	
						<td>포인트</td>
						<td>활동상태</td>
						<td>상태변경</td>
					</tr>	
					<tr>
						<td>회원이 없습니다.</td>
					</tr>
	   			</table>
	   		<% } else { // 회원이 있으면 %>
  				<table>
					<tr>
						<td>No.</td>	  
						<td>ID</td>	 		
			   			<td>이름</td>	
						<td>연락처</td>	
						<td>주소</td>	
						<td>등급</td>	
						<td>포인트</td>
						<td>활동상태</td>
						<td>상태변경</td>
					</tr>	
					<%-- 회원 목록 반복해서 뿌리기 	
					<% 
						String memberId = "null"; 
						for(int i=0 ; i < memberList.size() ; i++){
							MemberSignupDTO memberDTO = memberList.get(i);
							String memid = memberDTO.getMemId();
							MemDataDTO memDataDTO = memDataDAO.getMemData(memid);
							
							System.out.println("회원 getMemId " + memid);
							System.out.println("회원수 " + count);
					%>
					<tr>
						<td><%= number-- %></td>
						<td><%= memberDTO.getMemId() %></td>
						<td><%= memberDTO.getMemName() %></td>
						<td><%= memberDTO.getMemTel() %></td>
						<td><%= memberDTO.getMemAd() %></td>
						<td>Level<%= memDataDTO.getMemLevel() %></td>
						<td><%= memDataDTO.getMemPoint() %>P</td>
							<% if(memberDTO.getMemStatus() == 1){ %>
								<td>활동중</td>
							<% } else {  %>
								<td>활동 중지</td>
						<% } %>
						
						<% if(memberDTO.getMemId().equals("admin")){  // 관리자 이면 %>
								<td><button disabled>관리자 계정</button></td>
						<% } else if(memberDTO.getMemStatus() == 1){ 
								System.out.println("memberDTO.getMemStatus() 진입");
								memberId = memberDTO.getMemId(); 
								pageNum = request.getParameter("pageNum");
								
								if(pageNum == null || pageNum.equals(null) || pageNum.equals("null")){
									pageNum = "1";
								} %>
								<td><button onclick="myConfirm('<%= memberId %>','<%= pageNum %>')">활동중지</button></td>
						
						<% }else { // 활동 중지 상태이면 %>
								<td><button disabled>활동중지 계정</button></td>
						<% } %>
					</tr>
					<% } // for%>
	   		</table>
	   		
	   		<script>
				function myConfirm(memberId, pageNum) {
				                    
				var ok = confirm("해당 회원을 활동중지 시키겠습니까?")
					if(ok) location.href='memberStopPro.jsp?memberId='+memberId+'&pageNum='+pageNum;
				}
				
			</script>
	   		
	   		
	   		<% } // 회원이 있으면 %>
	   		
				<br />
				
				
			   <%-- 게시판 목록 페이지 번호 뷰어 
			   <div align="center">
			   <% if(count > 0) { 
			         // 한페이지에 보여줄 번호의 개수 
			         int pageNumSize = 5; 
			         // 총 몇페이지 나오는지 계산 
			         int pageCount = count / pageSize + (count % pageSize == 0 ? 0 : 1);
			         // 현재 페이지에 띄울 첫번째 페이지 번호 
			         int startPage = ((currentPage - 1) / pageSize) * pageNumSize + 1; 
			         // 현재 페이지에 띄울 마지막 페이지번호  (startPage ~ endPage까지 번호 반복해서 뿌릴)
			         int endPage = startPage + pageNumSize - 1; 
			      if(endPage > pageCount) { endPage = pageCount; } // 마지막 페이지번호 조정 
			
			      if(startPage > pageNumSize) { 
			         if(sel != null && search != null) { %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage-1%>&sel=<%=sel%>&search=<%=search%>"> &lt; &nbsp; </a>
			        <% }else if(topSel != null && topSelVal != null){ %>   
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage-1%>&topSel=<%=topSel%>&topSelVal=<%=topSelVal%>"> &lt; &nbsp; </a>
			         <%}else{%>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage-1%>"> &lt; &nbsp; </a>
			         <%}
			      }
			      
			      for(int i = startPage; i <= endPage; i++) { 
			         if(sel != null && search != null) { %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=i%>&sel=<%=sel%>&search=<%=search%>"> &nbsp; <%= i %> &nbsp; </a>
			      <% } else if(topSel != null && topSelVal != null){ %>   
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=i%>&topSel=<%=topSel%>&topSelVal=<%=topSelVal%>"> &nbsp; <%= i %> &nbsp; </a>
			         <%}else{ %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=i%>"> &nbsp; <%= i %> &nbsp; </a> 
			         <%} 
			      }
			      
			      if(endPage < pageCount) { 
			         if(sel != null && search != null) { %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage+pageNumSize%>&sel=<%=sel%>&search=<%=search%>"> &nbsp; &gt; </a>
			     <%  }else if(topSel != null && topSelVal != null){ %>   
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage+pageNumSize%>&topSel=<%=topSel%>&topSelVal=<%=topSelVal%>"> &nbsp; &gt; </a>
			      <%   }else{ %>
			            <a class="pageNums" href="adminMypage.jsp?pageNum=<%=startPage+pageNumSize%>"> &nbsp; &gt; </a>
			      <%	}
			     	 } 
			      } %>
			
			      <br /><br />
	   		
	   		<%-- 작성자/내용 검색 
		<form action="adminMypage.jsp">
			<select name="sel">
				<option value="memId" selected>회원 ID</option>
				<option value="memName">회원 이름</option>
			</select>
			<input type="text" name="search" /> 
			<input type="submit" value="검색" />
		</form>
		<br />
		
		<button onclick="window.location='adminMypage.jsp'"> 전체 회원보기 </button>
		                    
			</div> <%-- 게시판 페이지 뷰어 
		</div> <%-- 회원관리  
   	</div> <%-- row  
   </div>	<%-- 컨테이너 



--%>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-A3rJD856KowSb7dwlZdYEkO39Gagi7vIsF0jrRAoQmDKKtQBHUuLZ9AsSv4jD4Xa" crossorigin="anonymous"></script>
<script src="/docs/5.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-A3rJD856KowSb7dwlZdYEkO39Gagi7vIsF0jrRAoQmDKKtQBHUuLZ9AsSv4jD4Xa" crossorigin="anonymous"></script>	

</body>
<%-- ***********푸터(0801 수정) *********** --%>
<br /><br /><br />
<div class="container">
  <footer class="d-flex flex-wrap justify-content-between align-items-center py-3 my-4 border-top">
    <p class="col-md-4 mb-0 text-muted">&copy; BallonTeer (사단법인희망풍선)</p>

    <a href="/" class="col-md-4 d-flex align-items-center justify-content-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
      <svg class="bi me-2" width="40" height="32"><use xlink:href="#bootstrap"/></svg>
    </a>

    <ul class="nav col-md-4 justify-content-end">
         <%if (session.getAttribute("memId")==null){ %>
            <li class="nav-item"><a href="/project/main/main.jsp" class="nav-link px-2 text-muted">메인</a></li>
      <% }else { %>
         <%if(category.equals("mem")){ %>
            <li class="nav-item"><a href="/project/main/memberMain.jsp" class="nav-link px-2 text-muted">메인</a></li>
         <% } else { %>
            <li class="nav-item"><a href="/project/main/main.jsp" class="nav-link px-2 text-muted">메인</a></li>
         <% } 
         } %>
         
      <li class="nav-item"><a href="/project/volPage/volBoardMain.jsp" class="nav-link px-2 text-muted">봉사</a></li>
      <li class="nav-item"><a href="/project/pointPage/pointShop.jsp" class="nav-link px-2 text-muted">포인트샵</a></li>
      <li class="nav-item"><a href="/project/freeBoard/freeBoardMain.jsp" class="nav-link px-2 text-muted">자유게시판</a></li>
      
      <% if(category != null){ %>
         <% if(category.equals("mem")){ %>
            <li class="nav-item"><a href="/project/memMyPage/memberMypage.jsp" class="nav-link px-2 text-muted">마이페이지</a></li>
         <% }else if(category.equals("cen")){ %>
            <li class="nav-item"><a href="/project/cenMyPage/centerMypage.jsp" class="nav-link px-2 text-muted">마이페이지</a></li>
         <% }else if(category.equals("admin")){ %>
            <li class="nav-item"><a href="/project/adminMyPage/adminMypage.jsp" class="nav-link px-2 text-muted">마이페이지</a></li>
         <% } 
      }%>
    </ul>
  </footer>
  </div>
  <% } %> 
</html>
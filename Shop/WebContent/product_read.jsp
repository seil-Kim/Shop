<%@ page contentType="text/html; charset=utf-8" 
    pageEncoding="UTF-8" %> 
<%@ page language="java" import="java.sql.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<HTML>
<HEAD><TITLE>상품 설명(이미지) 보기</TITLE>
<SCRIPT>
 function view(temp) {
  filename = "http://localhost:8090/Shop/upload/" + temp;
  i = window.open(filename, "win", "height=350,width=450,toolbar=0,menubar=0,scrollbars=1,resizable=1,status=0");
 }
</SCRIPT>
</HEAD>
<BODY>
<%

 String ca="";
 String pn="";
 
 if (request.getParameter("cat") != null) 
  if( !(request.getParameter("cat").equals("")) )
   ca=request.getParameter("cat");
 if (request.getParameter("pname") != null)
  if ( !(request.getParameter("pname").equals("")) )
   pn=request.getParameter("pname");
  
 out.println(pn);

 String sql=null;
 Connection con= null;
 Statement st =null;
 ResultSet rs =null;
 
 long id = Long.parseLong(request.getParameter("id"));
 
 String url = "http://localhost:8090/Shop/upload/";
 String small=null;
 
 out.print("[<A href=\"product_list.jsp?go="+ request.getParameter("go"));
 out.print("&cat="+ ca +"&pname="+pn+"\">상품 목록으로</A>]");
 
 try {
  Class.forName("oracle.jdbc.OracleDriver");
 } catch (ClassNotFoundException e ) {
  out.println(e);
 }
 
 try{
  con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "hr", "hr");
 } catch (SQLException e) {
  out.println(e);
 }

 try {
  st = con.createStatement();
  sql = "select * from product where id="+id;
  rs = st.executeQuery(sql);
  if (!(rs.next()))  {
   out.println("해당 내용이 없습니다");
  } else {
   small=url+rs.getString("small");
   out.println("<TABLE width=500 border=0 >");
   out.println("<TR><TH rowspan=3>");
 
   out.println("<A href=JavaScript:view(\""+rs.getString("large")+"\")>"); 
   out.println("<IMG width=100 height=100 src="+small+">");
   out.println("<BR>확대</A></TH>");
   out.println("<TH bgcolor=#003399>");
   out.println("<FONT face=굴림 color=white>");
   out.println(rs.getString("pname")+"("+rs.getLong("id")+")");
   out.println("---작성자:"+rs.getString("wname"));
   out.println("</FONT></TH></TR>");  
   out.println("<TR>");
   out.println("<TD>");
   out.println("<U>상세 설명 :</U><BR>");
   out.println(rs.getString("description") );
   out.println("</TD></TR>"); 
   out.println("<TR><TD align=right>");   
   out.println("제조(공급)원:"+rs.getString("sname")+"<BR>");
   out.println("시중가:<STRIKE>"+rs.getString("price")+"</STRIKE>원");
   out.println("판매가:"+rs.getString("downprice")+"원");
   out.println("</TD></TR>");  
   out.println("</TABLE>");
  }
  rs.close();
  st.close();
  con.close();
 } catch (SQLException e) {
  out.println(e);
 } 
%>
</BODY>
</HTML>
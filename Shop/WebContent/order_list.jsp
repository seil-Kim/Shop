<%@ page contentType="text/html;charset=utf-8" %> 
<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" %> 
<% request.setCharacterEncoding("utf-8"); %>
<HTML>
<HEAD><TITLE>주문서 내역</TITLE></HEAD>
<BODY>
[<A href="shop_list.jsp">쇼핑 목록으로 </A>]
<%
 String sql=null;
 Connection con= null;
 Statement st1 =null;
 Statement st2 =null;
 ResultSet rs1 =null;
 ResultSet rs2 =null;

 int count=0;
 int price=0;
 int qty=0;
 String cond="";
 long id=0;
 
 if (request.getParameter("id")!=null) {
  id = Long.parseLong(request.getParameter("id"));
  cond = " where id="+id;
 } else 
  cond = " order by id desc";  
  
 NumberFormat nf= NumberFormat.getNumberInstance();
 String totalstr="";
 
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
  st1 = con.createStatement();
  st2 = con.createStatement();
 
  sql = "select * from saleorder"+ cond;
  rs1 = st1.executeQuery(sql);

  if (!(rs1.next())) 
   out.println("해당 내용이 없습니다");
  else {
   do {
    totalstr =nf.format(rs1.getLong("total"));
    count =rs1.getInt("prodcount");
    id=rs1.getLong("id");
    out.println("<TABLE width=500 border=0 >");
    out.println("<TR><TH colspan=2 bgcolor=003399>");
    out.println("<FONT color=white>주문 내역서</FONT></TH></TR>");
    out.println("<TR><TD width=20% bgcolor=eeeeee>");
    out.println("주문 번호</TD>");
    out.println("<TD bgcolor=eeeeee>"+id+"</TD></TR>");
    out.println("<TR><TD width=20% bgcolor=eeeeee>");
    out.println("주문 날짜</TD>");
    out.println("<TD bgcolor=eeeeee>"+rs1.getString("orderdate")+"</TD></TR>");
    out.println("<TR><TD bgcolor=eeeeee>고객 이름</TD>");
    out.println("<TD bgcolor=eeeeee>"+rs1.getString("name")+"</TD></TR>");
    out.println("<TR><TD bgcolor=eeeeee>결제 유형</TD>");
    out.println("<TD bgcolor=eeeeee>");
    out.println(rs1.getString("pay")+"("+rs1.getString("cardno")+")");
    out.println("</TD></TR>"); 
    out.println("<TR><TD bgcolor=eeeeee>배달 주소</TD>");
    out.println("<TD bgcolor=eeeeee>"+rs1.getString("addr")+"</TD></TR>");
    out.println("<TR><TD bgcolor=eeeeee>전화 번호</TD>");
    out.println("<TD bgcolor=eeeeee>"+rs1.getString("tel"));
    out.println("</TD></TR></TABLE>"); 

    sql = "select * from item where orderid="+id+" order by mynum";
    rs2 = st2.executeQuery(sql);

    if (rs2.next()) {
     out.println("<TABLE width=500 border=0 >");
     out.println("<TR><TH colspan=2 bgcolor=0033cc>");
     out.println("<FONT color=white>상품 코드</FONT></TH>");
     out.println("<TH  bgcolor=0033cc>");
     out.println("<FONT color=white>상품 이름</FONT></TH>");
     out.println("<TH  bgcolor=0033cc>");
     out.println("<FONT color=white>주문 수량</FONT></TH>");
     out.println("<TH  bgcolor=0033cc>");
     out.println("<FONT  color=white>판매가격</FONT></TH>");
     out.println("<TH  bgcolor=0033cc>");
     out.println("<FONT color=white>판매가격*수량</FONT></TH></TR>");

     do {
      qty=rs2.getInt("quantity");
      price=rs2.getInt("price");

      out.println("<TR><TH width=5% bgcolor=0033cc>");
      out.println("<FONT color=white>"+rs2.getInt("mynum"));
      out.println("</FONT></TH>");
      out.println("<TD width=15% bgcolor=eeeeee>");
      out.println(rs2.getLong("prodid")+"</TD>");
      out.println("<TD width=100 bgcolor=eeeeee>");
      out.println(rs2.getString("pname")+"</TD>");
      out.println("<TD align=right bgcolor=eeeeee>"+qty+"</TD>");
      out.println("<TD align=right bgcolor=eeeeee>");
      out.println(nf.format(price)+"</TD>");
      out.println("<TD align=right bgcolor=eeeeee>");
      out.println(nf.format(price*qty)+"</TD></TR>");
     } while(rs2.next());
     out.println("<TR><TD align=right colspan=6>");
     out.println("주문 상품 :"+count+"품목&nbsp;합계금액 :"+totalstr+"원");
     out.println("</TD></TR></TABLE><BR>");
    }
   }while(rs1.next());   
  }

  st1.close();
  st2.close();
  con.close();
 } catch (SQLException e) {
  out.println(e);
 } 
%>
</BODY>
</HTML>
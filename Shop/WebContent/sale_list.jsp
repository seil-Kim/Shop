<%@ page contentType="text/html; charset=utf-8" %> 
<%@ page language="java" import="java.sql.*,java.text.*" %> 
<% request.setCharacterEncoding("utf-8"); %>
<HTML>
<HEAD><TITLE>쇼핑 목록 </TITLE>
<SCRIPT>
 function setvalue(f) {
  f.quantity.value=0;
  f.submit();
 }
</SCRIPT>
</HEAD>
<BODY>
<P align=center>
 <FONT color=#0000ff face=굴림 size=+1>
  <STRONG> 쇼핑 목록 </STRONG>
 </FONT>
</P> 
<CENTER>
<TABLE border=0 width=600 cellpadding=4 cellspacing=4 style="font-size:10pt">
 <TR>
  <TH width=5% bgcolor=#003399>
   <FONT color=black face=굴림><NOBR>번호</NOBR></FONT>
  </TH>
  <TH width=20% bgcolor=#003399>
   <FONT color=black face=굴림><NOBR>상품명</NOBR></FONT>
  </TH>
  <TH width=20% bgcolor=#003399>
   <FONT color=black face=굴림><NOBR>제조원</NOBR></FONT>
  </TH>
  <TH width=25% bgcolor=#003399>
   <FONT color=black face=굴림><NOBR>주문 수량</NOBR></FONT>
  </TH>
  <TH width=10% bgcolor=#003399>
   <FONT color=black face=굴림><NOBR>판매가(원)</NOBR></FONT>
  </TH>
  <TH width=15% bgcolor=#003399>
   <FONT color=black face=굴림><NOBR>합계(수량*판매가)</NOBR></FONT>
  </TH>
 </TR>
<%
 long id=0;
 
 session = request.getSession();
 
 String[] a = session.getValueNames();
 
 String where="1";

 String ca="";
 String pn="";
 int qty=0;
 int count=0;
 
 if (request.getParameter("go") != null)
  if(!(request.getParameter("go").equals("")) )
   where = request.getParameter("go");
 
 if (request.getParameter("cat") != null) 
  if( !(request.getParameter("cat").equals("")) )
   ca=request.getParameter("cat");
 
 if (request.getParameter("pname") != null) 
  if ( !(request.getParameter("pname").equals("")) ) 
   pn=request.getParameter("pname");
 
 NumberFormat nf= NumberFormat.getNumberInstance();

 String pricestr="";
 String hap="";
 int price=0;
 long total=0;
 
 Connection con= null;
 Statement st =null;
 ResultSet rs =null;
 String sql=null;
 
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
 
  for (int i=0; i< a.length ;i++) {
   id =Long.parseLong(a[i].trim());
   qty = ((Integer)session.getValue(a[i])).intValue();
   sql = "select * from product where id="+id; 
   rs = st.executeQuery(sql);
 
   if (rs.next()) { 
    count= count+1;
    price=rs.getInt("downprice");
    pricestr=nf.format(price); 
    hap=nf.format(price*qty); 
    total=total+(price*qty);
    out.println("<FORM method=post action=\'sale_upd.jsp\'>");   
    out.println("<TR>");
    out.println("<TH width=5%  bgcolor=#eeeeee>");
    out.println(i+1+"</TH>");
    out.println("<TD width=20% bgcolor=#eeeeee>");
    out.println(rs.getString("pname")+ "</TD>");
    out.println("<TD width=15% bgcolor=#eeeeee>");
    out.println(rs.getString("sname")+ "</TD>");
    out.println("<TD width=30% bgcolor=#eeeeee>");
    out.println("<INPUT type=text name=quantity size=2 value="+qty+">개<br/>");
    out.println("<INPUT type=hidden name=id value="+id+">");
    out.println("<INPUT type=hidden name=go value="+where+">");
    out.println("<INPUT type=hidden name=cat value="+ca+">");
    out.println("<INPUT type=hidden name=pname value="+pn+">");
    out.println("<INPUT type=submit value=수정>");
    out.println("<INPUT type=button value=삭제 onClick=\"setvalue(this.form);\">");
    out.println("</TD>");
    out.println("<TD width=10% bgcolor=#eeeeee align=right>");
    out.println(pricestr+ "</TD>");
    out.println("<TD width=10% bgcolor=#eeeeee align=right>");
    out.println(hap+ "</TD>");
    out.println("</TR></FORM>"); 
   }
  }   
 
  out.println("<TR>");
  out.println("<TD width=10% align=right colspan=6>");
  out.println("주문 상품 :"+count+ "품목&nbsp;&nbsp;");  
  out.println("주문 총 합계 금액 :"+nf.format(total)+ "원</TD>");     
  out.println("</TR>");   
  out.println("</TABLE>");
  st.close();
  con.close();
 
  out.print("[<A href=\"shop_list.jsp?go="+ where);
  out.print("&cat="+ ca +"&pname="+pn+"\">계속 쇼핑하기</A>]");
 
  out.println("[<A href=\"order.jsp?total="+total+"&count="+count+"\">주문하기</A>]");
 } catch (SQLException e) {
  out.println(e);
 }
%> 
</BODY>
</HTML>
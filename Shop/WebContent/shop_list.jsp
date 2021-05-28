<%@ page contentType="text/html; charset=utf-8" 
    pageEncoding="UTF-8" %> 
<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" %> 
<% request.setCharacterEncoding("utf-8"); %>
<HTML>
<HEAD><TITLE>쇼핑하기 </TITLE>
<SCRIPT language="javascript">
 function view(temp) {
  if (temp.length >0) { 
   url = "http://localhost:8090/Shop/upload/" + temp;
   window.open(url, "win", "height=350,width=450,toolbar=0,menubar=0,scrollbars=1,resizable=1,status=0");
  }
 }
</SCRIPT>
</HEAD>
<BODY>
<P align=center>
 <FONT color=#0000ff face=굴림 size=3>
  <STRONG>쇼핑하기</STRONG>
 </FONT>
</P> 
 
<FORM method=post name=search action="shop_list.jsp">
<TABLE border=0 width=95%>
 <TR>
  <TH align=right>
   <FONT size=-1>상품명으로 찾기</FONT>
   <INPUT type=text name=pname>
   <INPUT type=submit value="검색"></font>
  </TD>
 </TR>
 <TR>
  <TH>
   <FONT size=-1>
    [<A href="main.htm">메인으로</A>]
    <A href="shop_list.jsp">전체</A>-
    <A href="shop_list.jsp?cat=11">가구</A>-
    <A href="shop_list.jsp?cat=22">전기/전자</A>-
    <A href="shop_list.jsp?cat=33">부엌용품</A>-
    <A href="shop_list.jsp?cat=44">의류</A>-
    <A href="shop_list.jsp?cat=55">보석 및 악세사리</A>-
    <A href="shop_list.jsp?cat=66">헬스 기구</A>-
    <A href="shop_list.jsp?cat=77">컴퓨터 관련</A>-
    <A href="shop_list.jsp?cat=88">기타</A>
   </FONT>
  </TH>
 </TR>
</TABLE>
</FORM>
 
<CENTER>
<TABLE width=95% style="font-size:10pt">
<% 
 String cond="";
 String ca="";
 String pn="";
 
 if (request.getParameter("cat") != null) {
  if( !(request.getParameter("cat").equals("")) ) {
   ca=request.getParameter("cat");
   cond= " where category = '"+ ca+"'";
  }
 }
 
 if (request.getParameter("pname") != null) {
  if ( !(request.getParameter("pname").equals("")) ) {
   pn=request.getParameter("pname");
   cond= " where pname like '%"+ pn+"%'";
  }
 }

 Vector pname=new Vector();
 Vector sname=new Vector();
 Vector keyid=new Vector();
 Vector price=new Vector();
 Vector dprice=new Vector();
 Vector stock=new Vector();
 Vector small=new Vector();
 Vector large=new Vector();
 Vector description=new Vector();
 
 String url = "http://localhost:8090/Shop/image/";
 //String url = "D:/jsp/upload/";
 NumberFormat nf= NumberFormat.getNumberInstance();
 
 int stocki;
 String pricestr=null;
 String dpricestr=null;
 String filename="";
 
 int where=1;
 
 if (request.getParameter("go") != null) 
  where = Integer.parseInt(request.getParameter("go"));
 
 int nextpage=where+1;
 int priorpage = where-1;
 int startrow=0;
 int endrow=0;
 int maxrows=3;
 int totalrows=0;
 int totalpages=0;
 
 long id=0;
 
 Connection con= null;
 Statement st =null;
 ResultSet rs =null;
 
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
  String sql = "select * from product" ;
  sql = sql+ cond+  " order by id desc";
  rs = st.executeQuery(sql);
 
  if (!(rs.next()))  
   out.println("상품이 없습니다");
  else {
   do {
    keyid.addElement(new Long(rs.getLong("id")));
    pname.addElement(rs.getString("pname"));
    sname.addElement(rs.getString("sname"));
    price.addElement(new Integer(rs.getInt("price")));
    dprice.addElement(new Integer(rs.getInt("downprice"))); 
    stock.addElement(new Integer(rs.getInt("stock")));
    description.addElement(rs.getString("description"));
    small.addElement(rs.getString("small"));
    large.addElement(rs.getString("large"));
   }while(rs.next());
      
   totalrows = pname.size();
   totalpages = (totalrows-1)/maxrows +1;
 
   startrow = (where-1) * maxrows;
   endrow = startrow+maxrows-1  ;
 
   if (endrow >= totalrows)
    endrow=totalrows-1;
      
   for(int j=startrow;j<=endrow;j++) { 
    id= ((Long)keyid.elementAt(j)).longValue();
    stocki= ((Integer)stock.elementAt(j)).intValue();
    filename = url+(String)small.elementAt(j);
    pricestr= nf.format(price.elementAt(j)); 
    dpricestr=nf.format(dprice.elementAt(j)); 
 
    out.println("<TR ><TH rowspan=4>");
    out.println("<A href=JavaScript:view(\""+large.elementAt(j)+"\")>"); 
    out.println("<IMG border=0 width=70 height=70 src=\""+filename+"\">");
    out.println("<BR>확대</A></TH>");
    out.println("<TD bgcolor=#DFEDFF>");
    out.println("<FONT face='돋움체' color=black>");
    out.println( pname.elementAt(j)+"(코드:"+id+")");
    out.println("</FONT></TD></TR>");
    out.println("<TR>");
    out.println("<TD   bgcolor=#eeeeee>");
    out.println(description.elementAt(j));
    out.println("</TD></TR>"); 
    out.println("<TR><TD align=right>");
    out.println("시중가: <STRIKE>"+ pricestr+"</STRIKE>원&nbsp;&nbsp;");  
    out.println("판매가: "+ dpricestr+"원");  
    out.println("</TD></TR>"); 
    out.println("<FORM method=post name=search action=\"sale.jsp\">");
	out.println("<TR>");
    out.println("<TD align=right >");
    out.println("제조(공급)원 : "+sname.elementAt(j)+"&nbsp;&nbsp;");

    if (stocki >0) { 
     out.println("주문수량");
     out.println("<INPUT type=text name=quantity size=2 value=1>개");
     out.println("<INPUT type=hidden name=id value="+id+">");
     out.println("<INPUT type=hidden name=go value="+where+">");
     out.println("<INPUT type=hidden name=cat value="+ca+">");
     out.println("<INPUT type=hidden name=pname value="+pn+">");
     out.println("<INPUT type=submit value=\"바구니에 담기\">");
    } else
     out.println("품절");
    out.println("</TD></TR></FORM>"); 
   }
   rs.close();    
  }
  out.println("</TABLE>");
  st.close();
  con.close();
 } catch (SQLException e) {
  out.println(e);
 } 
 out.println("<HR color=#003399>");
 if (where > 1) {
  out.print("[<A href=\"shop_list.jsp?go=1"); 
  out.print("&cat="+ca+"&pname="+pn+"\">처음</A>]");
  out.print("[<A href=\"shop_list.jsp?go="+priorpage);
  out.print("&cat="+ca+"&pname="+pn+ "\">이전</A>]");
 } else {
  out.println("[처음]") ;
  out.println("[이전]") ;
 }
 
 if (where < totalpages) {
  out.print("[<A href=\"shop_list.jsp?go="+ nextpage);
  out.print("&cat="+ca+"&pname="+pn+"\">다음</A>]");
  out.print("[<A href=\"shop_list.jsp?go="+ totalpages);
  out.print("&cat="+ca+"&pname="+pn+"\">마지막</A>]");
 } else {
  out.println("[다음]");
  out.println("[마지막]");
 }
 
 out.println (where+"/"+totalpages); 
 out.println ("전체 상품수 :"+totalrows); 
%>
</BODY>
</HTML>
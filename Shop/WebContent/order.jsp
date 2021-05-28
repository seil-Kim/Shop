<%@ page contentType="text/html;charset=utf-8" %>  
<%@ page language="java" import="java.text.*" %> 
<% request.setCharacterEncoding("utf-8"); %> 
<% 

 int total=Integer.parseInt(request.getParameter("total"));
 int count=Integer.parseInt(request.getParameter("count"));
 
 NumberFormat nf= NumberFormat.getNumberInstance();
 String totalstr =  nf.format(total);   

%>
<HTML>
<HEAD>
<SCRIPT language="javascript">
 function check(f) {
  blank=false;
  for (i=0; i<f.elements.length;i++) {
   if (f.elements[i].value=="") {
    if (f.elements[i].name != "number") 
     blank=true ;
    if ((f.elements[i].name == "number") && (f.pay.value == "card"))
     blank=true ;
   }
  }

  if (blank==true) 
   alert("모든 항목을 입력하셔야 합니다.");
  else
   f.submit();
 }
</SCRIPT> 
</HEAD>
<BODY>
<P>
[<A href= "sale_list.jsp">장바구니 다시 보기</A>] 
<FORM method=post action="order_save.jsp">
<TABLE border=0 width=400 >
 <TR>
  <TH bgcolor=#003399 colspan=2>
   <FONT size=+1 color=white> 주문서 작성하기</FONT>
  </TH>
 </TR>
 <TR>
  <TH width=30% bgcolor=#0033cc>
   <FONT size=-1 color=white>이름</FONT>
  </TH>
  <TD bgcolor=#eeeeee>
   <INPUT type=text name=wname size=30>
  </TD>
 </TR>
 <TR>
  <TH width=30% bgcolor=#0033cc>
   <FONT size=-1 color=white>결제 유형</FONT>
  </TH>
  <TD bgcolor=#eeeeee>
   <FONT size=-1>
    <INPUT type=radio name=pay value="card">카드
    <INPUT type=radio name=pay value="cash">온라인 입금
   </FONT>
  </TD>
 </TR>
 <TR>
  <TH width=30% bgcolor=#0033cc>
   <FONT size=-1 color=white>카드 번호</FONT>
  </TH>
  <TD bgcolor=#eeeeee>
   <INPUT type=text name=number size=30>
  </TD>
 </TR>
 <TR>
  <TH width=30% bgcolor=#0033cc>
   <FONT size=-1 color=white>배달 주소</FONT>
  </TH>
  <TD bgcolor=#eeeeee>
   <INPUT type=text name=addr size=30>
  </TD>
 </TR>
 <TR>
  <TH width=30% bgcolor=#0033cc>
   <FONT size=-1 color=white>전화번호</FONT>
  </TH>
  <TD bgcolor=#eeeeee>
   <INPUT type=text name=tel size=30>
  </TD>
 </TR>
 <TR>
  <TH width=30% bgcolor=#0033cc>
   <FONT size=-1 color=white>주문 총 금액</FONT>
  </TH>
  <TD bgcolor=#eeeeee>
   <%=totalstr%>원
  </TD>
 </TR>
 <TR>
  <TD colspan=2>
   <INPUT type=hidden name=total value=<%=total%>>
   <INPUT type=hidden name=count value=<%=count%>>
   <INPUT type=button value=" 확인 " onClick="check(this.form)" >
   <INPUT type=reset value=" 다시쓰기 " >
  </TD>
 </TR>
</TABLE>
</CENTER>
</FORM>
</BODY>
</HTML>
<%@ page contentType="text/html; charset=utf-8" %> 
<% request.setCharacterEncoding("utf-8"); %>
<%
try {
 session=request.getSession();
 String id = request.getParameter("id"); 
 
 int qty = Integer.parseInt(request.getParameter("quantity")); 
 String go= request.getParameter("go");
 String ca="";
 String pn="";
 
 if (request.getParameter("cat") != null) 
  if( !(request.getParameter("cat").equals("")) )
   ca=request.getParameter("cat");
 
 if (request.getParameter("pname") != null) 
  if ( !(request.getParameter("pname").equals("")) ) 
   pn=request.getParameter("pname");
 
 if (qty==0) 
  session.removeValue(id);
 else 
  session.putValue(id, new Integer(qty));   
 
 response.sendRedirect("sale_list.jsp?go="+go+"&cat="+ca+"&pname="+pn);
 
} catch (Exception e) {
  out.println(e);
} 
%>
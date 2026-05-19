<%-- filtro.jsp is now integrated into abnormalities.jsp via ?risk= parameter --%>
<%
  response.sendRedirect("abnormalities.jsp" + (request.getParameter("risk") != null ? "?risk=" + request.getParameter("risk") : ""));
%>

<%
  final String redirectURL = "/openspecimen/";
  response.setStatus(response.SC_MOVED_PERMANENTLY);
  response.sendRedirect(redirectURL);
%>

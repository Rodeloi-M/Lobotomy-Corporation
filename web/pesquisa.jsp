<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DataBase.DataBaseConnection"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Search – Lobotomy Corporation Wiki</title>
  <link rel="stylesheet" href="css/style.css">
  <style>body { overflow-y: auto; }</style>
</head>
<body>
<div class="main" style="margin-left:0; margin-top:0; padding:30px 36px;">

  <div class="page-header">
    <div class="breadcrumb">Wiki / <span>Search</span></div>
    <h1 class="page-title">Search Abnormalities</h1>
    <p class="page-subtitle">Search by name, code, or description</p>
  </div>

  <!-- SEARCH FORM -->
  <div style="margin-bottom:28px;">
    <form method="GET" action="pesquisa.jsp" style="display:flex;gap:10px;max-width:560px;">
      <input class="form-control" type="text" name="nome"
             placeholder="Search abnormality name or code…"
             value="<%= request.getParameter("nome") != null ? request.getParameter("nome") : "" %>"
             style="flex:1;">
      <button type="submit" class="btn-primary" style="padding:10px 22px;white-space:nowrap;">
        Search
      </button>
    </form>
  </div>

  <%
    String query = request.getParameter("nome");
    if (query != null && !query.trim().isEmpty()) {
      Connection con = null;
      try {
        con = DataBaseConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
          "SELECT * FROM abnormality WHERE nome LIKE ? OR codigo LIKE ? OR descricao LIKE ? ORDER BY nome ASC"
        );
        String like = "%" + query.trim() + "%";
        ps.setString(1, like);
        ps.setString(2, like);
        ps.setString(3, like);
        ResultSet rs = ps.executeQuery();

        int count = 0;
        boolean first = true;
  %>

  <% while (rs.next()) {
       if (first) { first = false; %>
  <div class="search-results-header">
    Results for <strong>"<%= query %>"</strong>:
  </div>
  <% } %>

  <%
    count++;
    String risk = rs.getString("riskLevel");
    String riskClass = risk != null ? "badge-" + risk.toLowerCase() : "badge-zayin";
    String img = rs.getString("imagem");
  %>
  <a class="list-card animate-in" href="abnormality.jsp?id=<%= rs.getInt("id") %>" target="_top">
    <% if (img != null && !img.isEmpty()) { %>
    <img src="images/<%= img %>" alt="<%= rs.getString("nome") %>">
    <% } else { %>
    <div class="img-placeholder-sm">⬡</div>
    <% } %>
    <div class="list-card-info">
      <div class="list-card-name"><%= rs.getString("nome") %></div>
      <div class="list-card-meta">
        <span><%= rs.getString("codigo") != null ? rs.getString("codigo") : "" %></span>
        <span><%= rs.getString("attackType") != null ? rs.getString("attackType") : "" %></span>
      </div>
      <% if (rs.getString("descricao") != null && !rs.getString("descricao").isEmpty()) { %>
      <div style="font-size:12px;color:var(--text-muted);margin-top:6px;max-width:500px;">
        <%= rs.getString("descricao").length() > 100
          ? rs.getString("descricao").substring(0, 100) + "…"
          : rs.getString("descricao") %>
      </div>
      <% } %>
    </div>
    <div class="list-card-actions">
      <span class="badge <%= riskClass %>"><%= risk != null ? risk : "—" %></span>
      <span class="btn-sm btn-sm-primary">View →</span>
    </div>
  </a>

  <%
      }
      rs.close();
      ps.close();

      if (count == 0) {
  %>
  <div class="empty-state">
    <div class="empty-icon">🔍</div>
    <h3>No Results Found</h3>
    <p>No abnormalities match "<strong><%= query %></strong>". Try a different search term.</p>
  </div>
  <%
      } else {
  %>
  <div style="font-size:12px;color:var(--text-muted);margin-top:16px;">
    <%= count %> result<%= count == 1 ? "" : "s" %> found
  </div>
  <%
      }

      } catch (Exception e) {
  %>
  <div class="info-box">
    <span class="info-box-icon">⚠</span>
    Database error: <%= e.getMessage() %>
  </div>
  <%
      } finally {
        if (con != null) try { con.close(); } catch (Exception ignored) {}
      }

    } else {
      // No query yet — show tip
  %>
  <div class="info-box">
    <span class="info-box-icon">ℹ</span>
    Type an abnormality name, classification code, or keyword to search the archive.
  </div>
  <%
    }
  %>

</div>
</body>
</html>

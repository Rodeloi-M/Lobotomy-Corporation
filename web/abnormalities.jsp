<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DataBase.DataBaseConnection"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Abnormalities – Lobotomy Corporation Wiki</title>
  <link rel="stylesheet" href="css/style.css">
  <style>body { overflow-y: auto; }</style>
</head>
<body>
<div class="main" style="margin-left:0; margin-top:0; padding:30px 36px;">

  <div class="page-header">
    <div class="breadcrumb">Wiki / <span>Abnormalities</span></div>
    <h1 class="page-title">Abnormalities</h1>
    <p class="page-subtitle">Complete archive of all documented abnormalities</p>
  </div>

  <%
    String riskFilter = request.getParameter("risk");
    String[] risks = {"ZAYIN", "TETH", "HE", "WAW", "ALEPH"};
  %>

  <!-- FILTER BAR -->
  <div class="filter-bar">
    <span class="filter-label">Risk Level:</span>
    <a class="filter-pill <%= (riskFilter == null) ? "active" : "" %>" href="abnormalities.jsp">All</a>
    <% for (String r : risks) { %>
    <a class="filter-pill <%= r.equals(riskFilter) ? "active" : "" %>" href="abnormalities.jsp?risk=<%= r %>"><%= r %></a>
    <% } %>
  </div>

  <%
    Connection con = null;
    try {
      con = DataBaseConnection.getConnection();

      PreparedStatement ps;
      if (riskFilter != null && !riskFilter.isEmpty()) {
        ps = con.prepareStatement("SELECT * FROM abnormality WHERE riskLevel = ? ORDER BY nome ASC");
        ps.setString(1, riskFilter);
      } else {
        ps = con.prepareStatement("SELECT * FROM abnormality ORDER BY nome ASC");
      }

      ResultSet rs = ps.executeQuery();
      int count = 0;
  %>

  <div class="cards-grid">
  <%
      while (rs.next()) {
        count++;
        String risk = rs.getString("riskLevel");
        String riskClass = risk != null ? "badge-" + risk.toLowerCase() : "badge-zayin";
        String img = rs.getString("imagem");
  %>
    <a class="card animate-in" href="abnormality.jsp?id=<%= rs.getInt("id") %>" target="_top">
      <% if (img != null && !img.isEmpty()) { %>
      <img class="card-image" src="images/<%= img %>" alt="<%= rs.getString("nome") %>">
      <% } else { %>
      <div class="card-image-placeholder">⬡</div>
      <% } %>
      <div class="card-body">
        <div class="card-title"><%= rs.getString("nome") %></div>
        <div class="card-code"><%= rs.getString("codigo") %></div>
        <% if (rs.getString("attackType") != null) { %>
        <div style="font-size:11px;color:var(--text-muted);margin-top:2px;">
          <%= rs.getString("attackType") %> · <%= rs.getString("attackDamage") != null ? rs.getString("attackDamage") : "—" %>
        </div>
        <% } %>
      </div>
      <div class="card-footer">
        <span class="badge <%= riskClass %>"><%= risk != null ? risk : "—" %></span>
        <div style="display:flex;gap:4px;">
          <a class="btn-sm btn-sm-ghost" href="editar.jsp?id=<%= rs.getInt("id") %>" target="_top"
             onclick="event.stopPropagation();" title="Edit">✏</a>
          <a class="btn-sm" href="apagar.jsp?id=<%= rs.getInt("id") %>" target="_top"
             onclick="event.stopPropagation();" title="Delete"
             style="background:rgba(181,64,64,.12);color:var(--aleph);">🗑</a>
        </div>
      </div>
    </a>
  <%
      }
      rs.close();
      ps.close();

      if (count == 0) {
  %>
    <div class="empty-state" style="grid-column:1/-1;">
      <div class="empty-icon">⬡</div>
      <h3>No Abnormalities Found</h3>
      <p>
        <% if (riskFilter != null) { %>
          No entries with risk level <strong><%= riskFilter %></strong>.
          <a href="abnormalities.jsp">Show all</a>
        <% } else { %>
          The archive is empty. <a href="inserir.jsp" target="_top">Add the first entry.</a>
        <% } %>
      </p>
    </div>
  <%
      } else {
  %>
  </div>

  <div style="font-size:12px;color:var(--text-muted);margin-top:16px;">
    <%= count %> abnormalit<%= count == 1 ? "y" : "ies" %><%= riskFilter != null ? " with risk level " + riskFilter : "" %> in archive
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
  %>

</div>
</body>
</html>

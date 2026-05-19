<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DataBase.DataBaseConnection"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Home – Lobotomy Corporation Wiki</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    body { overflow-y: auto; }
  </style>
</head>
<body>
<div class="main" style="margin-left:0; margin-top:0; padding:30px 36px;">

  <!-- HERO -->
  <div class="hero-banner animate-in">
    <div class="hero-content">
      <div class="hero-eyebrow">Welcome, Manager</div>
      <h1 class="hero-title">Lobotomy Corporation<br>Abnormality Archive</h1>
      <p class="hero-desc">
        Browse all known abnormalities, read containment reports,
        E.G.O. equipment data, observation logs and more.
        Knowledge is the key to containment.
      </p>
    </div>
    <div class="hero-ornament">異</div>
  </div>

  <!-- FEATURED -->
  <div class="section-title">Featured Abnormality</div>

  <%
    Connection con = null;
    try {
      con = DataBaseConnection.getConnection();

      // Featured: first entry or ID=1
      PreparedStatement psFeat = con.prepareStatement(
        "SELECT * FROM abnormality ORDER BY id ASC LIMIT 1"
      );
      ResultSet rsFeat = psFeat.executeQuery();

      if (rsFeat.next()) {
        String riskClass = rsFeat.getString("riskLevel") != null
          ? "badge-" + rsFeat.getString("riskLevel").toLowerCase()
          : "badge-zayin";
  %>
  <a class="list-card animate-in" href="abnormality.jsp?id=<%= rsFeat.getInt("id") %>" target="_top"
     style="margin-bottom:32px; border-color: var(--border-accent);">
    <%
      String imgFeat = rsFeat.getString("imagem");
      if (imgFeat != null && !imgFeat.isEmpty()) {
    %>
    <img src="images/<%= imgFeat %>" alt="<%= rsFeat.getString("nome") %>" style="width:90px;height:90px;border-radius:8px;">
    <% } else { %>
    <div class="img-placeholder-sm" style="width:90px;height:90px;font-size:32px;">⬡</div>
    <% } %>
    <div class="list-card-info">
      <div class="list-card-name" style="font-size:17px;"><%= rsFeat.getString("nome") %></div>
      <div class="list-card-meta" style="margin-bottom:8px;">
        <span><%= rsFeat.getString("codigo") %></span>
        <span><%= rsFeat.getString("attackType") != null ? rsFeat.getString("attackType") : "" %></span>
      </div>
      <span class="badge <%= riskClass %>"><%= rsFeat.getString("riskLevel") %></span>
      <% if (rsFeat.getString("descricao") != null) { %>
      <p style="margin-top:8px;font-size:13px;color:var(--text-secondary);max-width:500px;">
        <%= rsFeat.getString("descricao").length() > 120
          ? rsFeat.getString("descricao").substring(0, 120) + "…"
          : rsFeat.getString("descricao") %>
      </p>
      <% } %>
    </div>
    <div class="list-card-actions">
      <span class="btn-sm btn-sm-primary">Open Article →</span>
    </div>
  </a>
  <%
      }
      rsFeat.close();
      psFeat.close();
  %>

  <!-- RECENTLY ADDED -->
  <div class="section-title">Recently Added</div>
  <div class="cards-grid">
  <%
    PreparedStatement psRecent = con.prepareStatement(
      "SELECT * FROM abnormality ORDER BY id DESC LIMIT 6"
    );
    ResultSet rsRecent = psRecent.executeQuery();
    boolean hasAny = false;
    while (rsRecent.next()) {
      hasAny = true;
      String risk = rsRecent.getString("riskLevel");
      String riskClass2 = risk != null ? "badge-" + risk.toLowerCase() : "badge-zayin";
      String img = rsRecent.getString("imagem");
  %>
    <a class="card animate-in" href="abnormality.jsp?id=<%= rsRecent.getInt("id") %>" target="_top">
      <% if (img != null && !img.isEmpty()) { %>
      <img class="card-image" src="images/<%= img %>" alt="<%= rsRecent.getString("nome") %>">
      <% } else { %>
      <div class="card-image-placeholder">⬡</div>
      <% } %>
      <div class="card-body">
        <div class="card-title"><%= rsRecent.getString("nome") %></div>
        <div class="card-code"><%= rsRecent.getString("codigo") %></div>
      </div>
      <div class="card-footer">
        <span class="badge <%= riskClass2 %>"><%= risk != null ? risk : "—" %></span>
      </div>
    </a>
  <%
    }
    rsRecent.close();
    psRecent.close();

    if (!hasAny) {
  %>
    <div class="empty-state" style="grid-column:1/-1;">
      <div class="empty-icon">⬡</div>
      <h3>No Abnormalities Yet</h3>
      <p>The archive is empty. <a href="inserir.jsp" target="_top">Add the first entry.</a></p>
    </div>
  <%
    }

    // Stats row
    Statement stCount = con.createStatement();
    ResultSet rsCount = stCount.executeQuery("SELECT COUNT(*) AS total, riskLevel FROM abnormality GROUP BY riskLevel");
  %>
  </div>

  <!-- STATS -->
  <div class="section-title" style="margin-top:36px;">Archive Statistics</div>
  <div style="display:flex;gap:12px;flex-wrap:wrap;margin-bottom:30px;">
    <%
      while (rsCount.next()) {
        String rl = rsCount.getString("riskLevel");
        String rc = rl != null ? "badge-" + rl.toLowerCase() : "badge-zayin";
    %>
    <div style="background:var(--bg-card);border:1px solid var(--border);border-radius:8px;padding:16px 24px;text-align:center;min-width:100px;">
      <div style="font-size:26px;font-family:'Cinzel',serif;font-weight:700;color:var(--text-primary);">
        <%= rsCount.getInt("total") %>
      </div>
      <span class="badge <%= rc %>" style="margin-top:6px;display:inline-flex;"><%= rl != null ? rl : "Unknown" %></span>
    </div>
    <%
      }
      rsCount.close();
      stCount.close();
    %>
  </div>

  <%
    } catch (Exception e) {
  %>
  <div class="info-box">
    <span class="info-box-icon">⚠</span>
    Database connection error: <%= e.getMessage() %>
  </div>
  <%
    } finally {
      if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
  %>

</div>
</body>
</html>

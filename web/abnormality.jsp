<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DataBase.DataBaseConnection"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Abnormality – Lobotomy Corporation Wiki</title>
  <link rel="stylesheet" href="css/style.css">
  <style>body { overflow-y: auto; }</style>
</head>
<body>
<div class="main" style="margin-left:0; margin-top:0; padding:30px 36px;">

  <%
    Connection con = null;
    try {
      con = DataBaseConnection.getConnection();
      int id = Integer.parseInt(request.getParameter("id"));

      PreparedStatement ps = con.prepareStatement("SELECT * FROM abnormality WHERE id = ?");
      ps.setInt(1, id);
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
        String nome    = rs.getString("nome");
        String codigo  = rs.getString("codigo");
        String risk    = rs.getString("riskLevel");
        String atkType = rs.getString("attackType");
        String atkDmg  = rs.getString("attackDamage");
        int    eboxes  = rs.getInt("eboxes");
        String descr   = rs.getString("descricao");
        String img     = rs.getString("imagem");
        String riskClass = risk != null ? "badge-" + risk.toLowerCase() : "badge-zayin";
  %>

  <div class="page-header">
    <div class="breadcrumb">
      Wiki / <a href="abnormalities.jsp" style="color:var(--text-secondary);">Abnormalities</a> / <span><%= nome %></span>
    </div>
  </div>

  <div class="detail-layout">

    <!-- LEFT: image + info table -->
    <div class="detail-sidebar-card">
      <% if (img != null && !img.isEmpty()) { %>
      <img src="images/<%= img %>" alt="<%= nome %>">
      <% } else { %>
      <div class="img-placeholder" style="width:100%;aspect-ratio:1;background:linear-gradient(135deg,#14141a,#1e1e26);display:flex;align-items:center;justify-content:center;font-size:64px;color:var(--text-muted);">⬡</div>
      <% } %>
      <table class="info-table">
        <tr>
          <th>Code</th>
          <td style="font-family:'Courier New',monospace;font-size:12px;"><%= codigo != null ? codigo : "—" %></td>
        </tr>
        <tr>
          <th>Risk Level</th>
          <td><span class="badge <%= riskClass %>"><%= risk != null ? risk : "—" %></span></td>
        </tr>
        <tr>
          <th>Attack Type</th>
          <td><%= atkType != null ? atkType : "—" %></td>
        </tr>
        <tr>
          <th>Attack Damage</th>
          <td><%= atkDmg != null ? atkDmg : "—" %></td>
        </tr>
        <tr>
          <th>E-Boxes</th>
          <td><%= eboxes > 0 ? eboxes : "—" %></td>
        </tr>
      </table>
      <div style="padding:14px 16px;display:flex;flex-direction:column;gap:8px;">
        <a class="btn-primary" href="editar.jsp?id=<%= id %>" style="text-align:center;font-size:13px;padding:9px;text-decoration:none;display:block;">
          ✏ Edit Entry
        </a>
        <a class="btn-secondary" href="abnormalities.jsp" style="text-align:center;font-size:13px;padding:9px;display:block;">
          ← Back to Archive
        </a>
        <a class="btn-danger" href="apagar.jsp?id=<%= id %>" style="text-align:center;font-size:12px;padding:8px;display:block;">
          🗑 Delete Entry
        </a>
      </div>
    </div>

    <!-- RIGHT: description + lore -->
    <div class="detail-content animate-in">
      <div class="detail-name"><%= nome %></div>

      <h2>Description</h2>
      <% if (descr != null && !descr.isEmpty()) { %>
      <p><%= descr %></p>
      <% } else { %>
      <p style="color:var(--text-muted);font-style:italic;">No description recorded.</p>
      <% } %>

      <h2>Containment Information</h2>
      <p>
        This abnormality is classified under risk level
        <strong style="color:var(--accent);"><%= risk != null ? risk : "unknown" %></strong>.
        <% if (atkType != null) { %>
        It deals <strong><%= atkDmg != null ? atkDmg : "unknown" %></strong> damage of type
        <strong><%= atkType %></strong>.
        <% } %>
        <% if (eboxes > 0) { %>
        E-Box count: <strong><%= eboxes %></strong>.
        <% } %>
      </p>

      <h2>Work Interactions</h2>
      <div class="info-box">
        <span class="info-box-icon">ℹ</span>
        Work interaction data not yet recorded for this abnormality.
        Managers are advised to consult field logs.
      </div>

      <h2>E.G.O. Equipment</h2>
      <div class="info-box">
        <span class="info-box-icon">ℹ</span>
        E.G.O. data not yet documented. Update this entry with equipment information.
      </div>
    </div>
  </div>

  <%
      } else {
  %>
  <div class="empty-state">
    <div class="empty-icon">⬡</div>
    <h3>Abnormality Not Found</h3>
    <p>No entry with ID <%= request.getParameter("id") %>.</p>
    <a href="abnormalities.jsp" class="btn-secondary" style="margin-top:16px;display:inline-block;">← Back to Archive</a>
  </div>
  <%
      }
      rs.close();
      ps.close();

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

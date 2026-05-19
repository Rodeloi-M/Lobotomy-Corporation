<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DataBase.DataBaseConnection"%>
<%
  int deleteId = 0;
  try { deleteId = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}

  String nome = "";
  String confirmed = request.getParameter("confirmed");

  Connection con = null;
  String errorMsg = null;
  boolean deleted = false;

  try {
    con = DataBaseConnection.getConnection();

    if ("yes".equals(confirmed)) {
      // Perform deletion
      PreparedStatement ps = con.prepareStatement("DELETE FROM abnormality WHERE id = ?");
      ps.setInt(1, deleteId);
      ps.executeUpdate();
      ps.close();
      deleted = true;
    } else {
      // Fetch name for confirmation
      PreparedStatement ps = con.prepareStatement("SELECT nome FROM abnormality WHERE id = ?");
      ps.setInt(1, deleteId);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        nome = rs.getString("nome");
      }
      rs.close();
      ps.close();
    }
  } catch (Exception e) {
    errorMsg = e.getMessage();
  } finally {
    if (con != null) try { con.close(); } catch (Exception ignored) {}
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Delete – Lobotomy Corporation Wiki</title>
  <link rel="stylesheet" href="css/style.css">
  <style>body { overflow-y: auto; }</style>
</head>
<body>
<div class="main" style="margin-left:0; margin-top:0; padding:30px 36px;">

  <div class="page-header">
    <div class="breadcrumb">Wiki / <a href="abnormalities.jsp" style="color:var(--text-secondary);">Abnormalities</a> / <span>Delete</span></div>
    <h1 class="page-title">Delete Entry</h1>
  </div>

  <% if (errorMsg != null) { %>
  <div class="info-box" style="background:rgba(181,64,64,.08);border-color:rgba(181,64,64,.3);">
    <span class="info-box-icon">⚠</span>
    Database error: <%= errorMsg %>
  </div>

  <% } else if (deleted) { %>

  <div class="info-box" style="background:rgba(143,186,104,.08);border-color:rgba(143,186,104,.3);max-width:500px;">
    <span class="info-box-icon">✓</span>
    Entry deleted successfully.
  </div>
  <div style="margin-top:20px;">
    <a href="abnormalities.jsp" class="btn-primary" style="text-decoration:none;padding:10px 22px;">← Back to Archive</a>
  </div>

  <% } else if (!nome.isEmpty()) { %>

  <!-- Confirmation box -->
  <div style="max-width:480px;">
    <div style="background:rgba(181,64,64,.08);border:1px solid rgba(181,64,64,.35);border-radius:8px;padding:24px 28px;margin-bottom:24px;">
      <div style="font-size:28px;margin-bottom:12px;">⚠</div>
      <h2 style="font-family:'Cinzel',serif;font-size:16px;color:var(--aleph);margin-bottom:10px;">
        Confirm Deletion
      </h2>
      <p style="color:var(--text-secondary);font-size:14px;line-height:1.7;margin-bottom:6px;">
        You are about to permanently delete:
      </p>
      <p style="font-family:'Cinzel',serif;font-size:15px;color:var(--text-primary);margin-bottom:16px;">
        "<%= nome %>"
      </p>
      <p style="color:var(--text-muted);font-size:12px;">
        This action cannot be undone. The entry will be removed from the archive permanently.
      </p>
    </div>

    <div class="btn-group">
      <a href="apagar.jsp?id=<%= deleteId %>&confirmed=yes" class="btn-danger">
        Yes, Delete Entry
      </a>
      <a href="abnormality.jsp?id=<%= deleteId %>" class="btn-secondary">
        Cancel
      </a>
    </div>
  </div>

  <% } else { %>
  <div class="empty-state">
    <div class="empty-icon">⬡</div>
    <h3>Entry Not Found</h3>
    <p>No entry with that ID.</p>
    <a href="abnormalities.jsp" class="btn-secondary" style="display:inline-block;margin-top:16px;">← Back</a>
  </div>
  <% } %>

</div>
</body>
</html>

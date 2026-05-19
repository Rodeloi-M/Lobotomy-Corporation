<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DataBase.DataBaseConnection"%>
<%
  String msg = null;
  String msgType = "info";
  int editId = 0;
  try { editId = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}

  if ("POST".equals(request.getMethod())) {
    Connection con = null;
    try {
      con = DataBaseConnection.getConnection();
      PreparedStatement ps = con.prepareStatement(
        "UPDATE abnormality SET nome=?, codigo=?, eboxes=?, attackType=?, attackDamage=?, riskLevel=?, descricao=?, imagem=? WHERE id=?"
      );
      ps.setString(1, request.getParameter("nome"));
      ps.setString(2, request.getParameter("codigo"));
      String eb = request.getParameter("eboxes");
      ps.setInt(3, (eb != null && !eb.isEmpty()) ? Integer.parseInt(eb) : 0);
      ps.setString(4, request.getParameter("attackType"));
      ps.setString(5, request.getParameter("attackDamage"));
      ps.setString(6, request.getParameter("riskLevel"));
      ps.setString(7, request.getParameter("descricao"));
      ps.setString(8, request.getParameter("imagem"));
      ps.setInt(9, editId);
      ps.executeUpdate();
      ps.close();
      msg = "Entry updated successfully!";
      msgType = "success";
    } catch (Exception e) {
      msg = "Error: " + e.getMessage();
      msgType = "error";
    } finally {
      if (con != null) try { con.close(); } catch (Exception ignored) {}
    }
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Abnormality – Lobotomy Corporation Wiki</title>
  <link rel="stylesheet" href="css/style.css">
  <style>body { overflow-y: auto; }</style>
</head>
<body>
<div class="main" style="margin-left:0; margin-top:0; padding:30px 36px;">

  <div class="page-header">
    <div class="breadcrumb">Wiki / <a href="abnormalities.jsp" style="color:var(--text-secondary);">Abnormalities</a> / <span>Edit</span></div>
    <h1 class="page-title">Edit Abnormality</h1>
  </div>

  <% if (msg != null) { %>
  <div class="info-box" style="<%= "success".equals(msgType) ? "background:rgba(143,186,104,.08);border-color:rgba(143,186,104,.3);" : "error".equals(msgType) ? "background:rgba(181,64,64,.08);border-color:rgba(181,64,64,.3);" : "" %>">
    <span class="info-box-icon"><%= "success".equals(msgType) ? "✓" : "⚠" %></span>
    <%= msg %>
    <% if ("success".equals(msgType)) { %>
    <a href="abnormality.jsp?id=<%= editId %>" style="margin-left:12px;color:var(--accent);">View Entry →</a>
    <% } %>
  </div>
  <% } %>

  <%
    Connection con = null;
    try {
      con = DataBaseConnection.getConnection();
      PreparedStatement ps = con.prepareStatement("SELECT * FROM abnormality WHERE id = ?");
      ps.setInt(1, editId);
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
        String[] riskLevels = {"ZAYIN","TETH","HE","WAW","ALEPH"};
        String[] atkTypes = {"White","Black","Red","Blue","Pale"};
        String[] atkDmgs = {"Low","Medium","High","Very High","Extreme"};
        String curRisk = rs.getString("riskLevel");
        String curAtkType = rs.getString("attackType");
        String curAtkDmg = rs.getString("attackDamage");
  %>

  <div class="form-container animate-in">
    <form method="POST" action="editar.jsp?id=<%= editId %>">

      <div class="form-row">
        <div class="form-group">
          <label for="nome">Name *</label>
          <input class="form-control" type="text" id="nome" name="nome"
                 value="<%= rs.getString("nome") != null ? rs.getString("nome") : "" %>" required>
        </div>
        <div class="form-group">
          <label for="codigo">Classification Code</label>
          <input class="form-control" type="text" id="codigo" name="codigo"
                 value="<%= rs.getString("codigo") != null ? rs.getString("codigo") : "" %>">
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="riskLevel">Risk Level</label>
          <select class="form-control" id="riskLevel" name="riskLevel">
            <option value="">Select…</option>
            <% for (String r : riskLevels) { %>
            <option value="<%= r %>" <%= r.equals(curRisk) ? "selected" : "" %>><%= r %></option>
            <% } %>
          </select>
        </div>
        <div class="form-group">
          <label for="eboxes">E-Boxes</label>
          <input class="form-control" type="number" id="eboxes" name="eboxes"
                 value="<%= rs.getInt("eboxes") %>" min="0">
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="attackType">Attack Type</label>
          <select class="form-control" id="attackType" name="attackType">
            <option value="">Select…</option>
            <% for (String t : atkTypes) { %>
            <option value="<%= t %>" <%= t.equals(curAtkType) ? "selected" : "" %>><%= t %></option>
            <% } %>
          </select>
        </div>
        <div class="form-group">
          <label for="attackDamage">Attack Damage</label>
          <select class="form-control" id="attackDamage" name="attackDamage">
            <option value="">Select…</option>
            <% for (String d : atkDmgs) { %>
            <option value="<%= d %>" <%= d.equals(curAtkDmg) ? "selected" : "" %>><%= d %></option>
            <% } %>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label for="imagem">Image Filename</label>
        <input class="form-control" type="text" id="imagem" name="imagem"
               value="<%= rs.getString("imagem") != null ? rs.getString("imagem") : "" %>">
      </div>

      <div class="form-group">
        <label for="descricao">Description</label>
        <textarea class="form-control" id="descricao" name="descricao" rows="5"><%= rs.getString("descricao") != null ? rs.getString("descricao") : "" %></textarea>
      </div>

      <div class="btn-group">
        <button type="submit" class="btn-primary">Save Changes</button>
        <a href="abnormality.jsp?id=<%= editId %>" class="btn-secondary">Cancel</a>
      </div>

    </form>
  </div>

  <%
      } else {
  %>
  <div class="empty-state">
    <div class="empty-icon">⬡</div>
    <h3>Entry Not Found</h3>
    <a href="abnormalities.jsp" class="btn-secondary" style="display:inline-block;margin-top:16px;">← Back</a>
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

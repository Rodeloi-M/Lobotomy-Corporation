<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="DataBase.DataBaseConnection"%>
<%
  // Handle POST submission
  String msg = null;
  String msgType = "info";

  if ("POST".equals(request.getMethod())) {
    Connection con = null;
    try {
      con = DataBaseConnection.getConnection();
      PreparedStatement ps = con.prepareStatement(
        "INSERT INTO abnormality(nome, codigo, eboxes, attackType, attackDamage, riskLevel, descricao, imagem) VALUES(?,?,?,?,?,?,?,?)"
      );
      ps.setString(1, request.getParameter("nome"));
      ps.setString(2, request.getParameter("codigo"));
      String eboxStr = request.getParameter("eboxes");
      ps.setInt(3, (eboxStr != null && !eboxStr.isEmpty()) ? Integer.parseInt(eboxStr) : 0);
      ps.setString(4, request.getParameter("attackType"));
      ps.setString(5, request.getParameter("attackDamage"));
      ps.setString(6, request.getParameter("riskLevel"));
      ps.setString(7, request.getParameter("descricao"));
      ps.setString(8, request.getParameter("imagem"));
      ps.executeUpdate();
      ps.close();
      msg = "Abnormality added successfully!";
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
  <title>Add Abnormality – Lobotomy Corporation Wiki</title>
  <link rel="stylesheet" href="css/style.css">
  <style>body { overflow-y: auto; }</style>
</head>
<body>
<div class="main" style="margin-left:0; margin-top:0; padding:30px 36px;">

  <div class="page-header">
    <div class="breadcrumb">Wiki / <span>Add Abnormality</span></div>
    <h1 class="page-title">Add Abnormality</h1>
    <p class="page-subtitle">Register a new entry in the archive</p>
  </div>

  <% if (msg != null) { %>
  <div class="info-box" style="<%= "success".equals(msgType) ? "background:rgba(143,186,104,.08);border-color:rgba(143,186,104,.3);" : "error".equals(msgType) ? "background:rgba(181,64,64,.08);border-color:rgba(181,64,64,.3);" : "" %>">
    <span class="info-box-icon"><%= "success".equals(msgType) ? "✓" : "⚠" %></span>
    <%= msg %>
    <% if ("success".equals(msgType)) { %>
    <a href="abnormalities.jsp" style="margin-left:12px;color:var(--accent);">View Archive →</a>
    <% } %>
  </div>
  <% } %>

  <div class="form-container animate-in">

    <form method="POST" action="inserir.jsp">

      <div class="form-row">
        <div class="form-group">
          <label for="nome">Name *</label>
          <input class="form-control" type="text" id="nome" name="nome"
                 placeholder="e.g. One Sin and Hundreds of Good Deeds" required>
        </div>
        <div class="form-group">
          <label for="codigo">Classification Code *</label>
          <input class="form-control" type="text" id="codigo" name="codigo"
                 placeholder="e.g. O-03-03" required>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="riskLevel">Risk Level *</label>
          <select class="form-control" id="riskLevel" name="riskLevel" required>
            <option value="">Select risk level…</option>
            <option value="ZAYIN">ZAYIN (Lowest)</option>
            <option value="TETH">TETH</option>
            <option value="HE">HE</option>
            <option value="WAW">WAW</option>
            <option value="ALEPH">ALEPH (Highest)</option>
          </select>
        </div>
        <div class="form-group">
          <label for="eboxes">E-Boxes</label>
          <input class="form-control" type="number" id="eboxes" name="eboxes"
                 placeholder="0" min="0">
        </div>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="attackType">Attack Type</label>
          <select class="form-control" id="attackType" name="attackType">
            <option value="">Select type…</option>
            <option value="White">White (Physical)</option>
            <option value="Black">Black (Mental)</option>
            <option value="Red">Red (Fire)</option>
            <option value="Blue">Blue (Ice)</option>
            <option value="Pale">Pale (Pale)</option>
          </select>
        </div>
        <div class="form-group">
          <label for="attackDamage">Attack Damage</label>
          <select class="form-control" id="attackDamage" name="attackDamage">
            <option value="">Select damage…</option>
            <option value="Low">Low</option>
            <option value="Medium">Medium</option>
            <option value="High">High</option>
            <option value="Very High">Very High</option>
            <option value="Extreme">Extreme</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label for="imagem">Image Filename</label>
        <input class="form-control" type="text" id="imagem" name="imagem"
               placeholder="e.g. onesin.png  (place image in web/images/)">
      </div>

      <div class="form-group">
        <label for="descricao">Description</label>
        <textarea class="form-control" id="descricao" name="descricao"
                  rows="5"
                  placeholder="Enter containment report, lore, or description…"></textarea>
      </div>

      <div class="btn-group">
        <button type="submit" class="btn-primary">Add to Archive</button>
        <a href="abnormalities.jsp" class="btn-secondary">Cancel</a>
      </div>

    </form>
  </div>

</div>
</body>
</html>

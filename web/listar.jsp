<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.AbnormalityDAO, model.Abnormality, java.util.*" %>
<%!
    private String riskBadge(String r) {
        if (r == null) return "badge";
        if ("Zayin".equalsIgnoreCase(r))  return "badge badge-zayin";
        if ("Teth".equalsIgnoreCase(r))   return "badge badge-teth";
        if ("He".equalsIgnoreCase(r))     return "badge badge-he";
        if ("Waw".equalsIgnoreCase(r))    return "badge badge-waw";
        if ("Aleph".equalsIgnoreCase(r))  return "badge badge-aleph";
        return "badge";
    }
    private String attackBadge(String t) {
        if (t == null) return "badge";
        if ("Black".equalsIgnoreCase(t)) return "badge badge-black";
        if ("White".equalsIgnoreCase(t)) return "badge badge-white";
        if ("Red".equalsIgnoreCase(t))   return "badge badge-red";
        if ("Pale".equalsIgnoreCase(t))  return "badge badge-pale";
        return "badge";
    }
    private String safe(String s)  { return s != null ? s : "—"; }
    private String trunc(String s, int n) {
        if (s == null) return "—";
        return s.length() > n ? s.substring(0, n) + "…" : s;
    }
%>
<%
    AbnormalityDAO dao = new AbnormalityDAO();
    List<Abnormality> lista = new ArrayList<>();
    String errMsg = "";
    try { lista = dao.listarTodos(); }
    catch (Exception e) { errMsg = e.getMessage(); }

    // mensagem de operação anterior
    String opMsg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Anormalidades | Lobotomy Corporation Wiki</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="css/detalhe.css">
</head>
<body>

<header class="site-header">
  <div class="header-inner">
    <a href="index.html" class="logo">
      <img src="images/logo.svg" alt="L Corp" class="logo-img">
      <div>
        <div class="logo-text">Lobotomy Corp.</div>
        <div class="logo-sub">Abnormality Database</div>
      </div>
    </a>
    <nav class="main-nav">
      <a href="index.html">Início</a>
      <a href="listar.jsp" class="active">Anormalidades</a>
      <a href="filtrar.jsp">Filtrar</a>
      <a href="form.jsp">Gestão</a>
    </nav>
  </div>
</header>

<div class="page-header">
  <div class="container">
    <h1>Todas as Anormalidades</h1>
    <p>Total de registos: <strong style="color:var(--accent-yellow)"><%= lista.size() %></strong></p>
  </div>
</div>

<div class="container">

  <% if ("deleted".equals(opMsg)) { %>
    <div class="alert alert-success">✓ Anormalidade apagada com sucesso.</div>
  <% } %>
  <% if (!errMsg.isEmpty()) { %>
    <div class="alert alert-error">Erro de ligação à base de dados: <%= errMsg %>
      <br><small>Verifique se o MySQL está a correr e as credenciais em DBConnection.java.</small>
    </div>
  <% } %>

  <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:12px;">
    <p style="color:var(--text-muted);font-size:.85rem;">Listagem completa ordenada por nome</p>
    <div style="display:flex;gap:10px;">
      <a href="filtrar.jsp" class="btn btn-secondary btn-sm">⚙ Filtrar</a>
      <a href="form.jsp"    class="btn btn-primary   btn-sm">＋ Adicionar</a>
    </div>
  </div>

  <% if (lista.isEmpty() && errMsg.isEmpty()) { %>
    <div class="alert alert-info">
      Nenhuma anormalidade encontrada.
      Execute o ficheiro <code>Dump20260519.sql</code> no MySQL para carregar os dados.
      <a href="form.jsp" style="color:var(--accent-yellow)"> Ou adicionar manualmente →</a>
    </div>
  <% } else if (!lista.isEmpty()) { %>

  <!-- TABELA -->
  <div class="table-container">
    <table class="data-table">
      <thead>
        <tr>
          <th>#</th>
          <th>Nome</th>
          <th>Código</th>
          <th>Risco</th>
          <th>Ataque</th>
          <th>E-Boxes</th>
          <th>Qliphoth</th>
          <th>Benefício</th>
          <th>Descrição</th>
          <th>Acções</th>
        </tr>
      </thead>
      <tbody>
        <% for (Abnormality a : lista) { %>
        <tr>
          <td class="mono"><%= a.getId() %></td>
          <td>
            <a href="detalhe.jsp?id=<%= a.getId() %>"
               style="color:var(--accent-white);text-decoration:none;font-weight:600;
                      transition:color .15s;"
               onmouseover="this.style.color='var(--accent-yellow)'"
               onmouseout="this.style.color='var(--accent-white)'">
              <%= safe(a.getNome()) %>
            </a>
          </td>
          <td class="mono"><%= safe(a.getCodigo()) %></td>
          <td><span class="<%= riskBadge(a.getRiskLevel()) %>"><%= safe(a.getRiskLevel()) %></span></td>
          <td><span class="<%= attackBadge(a.getAttackType()) %>"><%= safe(a.getAttackType()) %></span></td>
          <td class="mono" style="text-align:center"><%= a.getEboxes() %></td>
          <td class="mono" style="text-align:center"><%= safe(a.getQliphothCounter()) %></td>
          <td style="text-align:center"><%= a.isFacilityBenefit() ? "✦" : "—" %></td>
          <td style="max-width:220px;color:var(--text-muted);font-size:.83rem;"><%= trunc(a.getDescricao(), 70) %></td>
          <td>
            <div class="actions-cell">
              <a href="detalhe.jsp?id=<%= a.getId() %>"  class="btn btn-secondary btn-sm">👁</a>
              <a href="form.jsp?editId=<%= a.getId() %>" class="btn btn-secondary btn-sm">✎</a>
              <form method="post" action="form.jsp" style="display:inline"
                    onsubmit="return confirm('Apagar \'<%= safe(a.getNome()).replace("'","") %>\'?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id"     value="<%= a.getId() %>">
                <button type="submit" class="btn btn-danger btn-sm">✗</button>
              </form>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>

  <!-- GRELHA DE CARTÕES -->
  <div class="divider"></div>
  <div class="section-header" style="margin-top:30px;">
    <h2 class="section-title">Vista em Grelha</h2>
  </div>
  <div class="card-grid">
    <% for (Abnormality a : lista) { %>
    <div class="card">
      <div class="card-header">
        <div>
          <div class="card-title">
            <a href="detalhe.jsp?id=<%= a.getId() %>"
               style="color:var(--accent-white);text-decoration:none;transition:color .15s"
               onmouseover="this.style.color='var(--accent-yellow)'"
               onmouseout="this.style.color='var(--accent-white)'">
              <%= safe(a.getNome()) %>
            </a>
          </div>
          <div class="card-code"><%= safe(a.getCodigo()) %></div>
        </div>
        <span class="<%= riskBadge(a.getRiskLevel()) %>"><%= safe(a.getRiskLevel()) %></span>
      </div>
      <div class="card-body"><%= trunc(a.getDescricao(), 100) %></div>
      <div class="card-footer">
        <span class="<%= attackBadge(a.getAttackType()) %>"><%= safe(a.getAttackType()) %></span>
        <% if (a.isFacilityBenefit()) { %>
          <span class="badge" style="color:var(--accent-yellow);border-color:rgba(245,197,24,.4)">✦</span>
        <% } %>
        <div style="flex:1"></div>
        <a href="detalhe.jsp?id=<%= a.getId() %>"  class="btn btn-secondary btn-sm">👁</a>
        <a href="form.jsp?editId=<%= a.getId() %>" class="btn btn-secondary btn-sm">✎</a>
      </div>
    </div>
    <% } %>
  </div>

  <% } %>
</div>

<footer class="site-footer">
  <div class="footer-inner">
    <div class="footer-col">
      <h4>Lobotomy Corp. Wiki</h4>
      <p style="font-size:.82rem;color:var(--text-dim);line-height:1.7;">Base de dados de Anormalidades.</p>
    </div>
    <div class="footer-col">
      <h4>Navegação</h4>
      <a href="index.html">Início</a>
      <a href="listar.jsp">Listar</a>
      <a href="filtrar.jsp">Filtrar</a>
      <a href="form.jsp">Gestão CRUD</a>
    </div>
    <div class="footer-col">
      <h4>Níveis de Risco</h4>
      <a href="filtrar.jsp?riskLevel=Zayin">Zayin</a>
      <a href="filtrar.jsp?riskLevel=Teth">Teth</a>
      <a href="filtrar.jsp?riskLevel=He">He</a>
      <a href="filtrar.jsp?riskLevel=Waw">Waw</a>
      <a href="filtrar.jsp?riskLevel=Aleph">Aleph</a>
    </div>
  </div>
  <div class="footer-bottom">
    <p>© 2026 — Lobotomy Corporation Wiki — Projeto Académico</p>
    <p>JSP + MySQL</p>
  </div>
</footer>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.AbnormalityDAO, model.Abnormality, java.util.*" %>
<%!
    // Métodos auxiliares declarados em bloco de declaração JSP (<%! ... %>)
    private String riskBadge(String r) {
        if (r == null) return "badge";
        if ("zayin".equalsIgnoreCase(r))  return "badge badge-zayin";
        if ("teth".equalsIgnoreCase(r))   return "badge badge-teth";
        if ("he".equalsIgnoreCase(r))     return "badge badge-he";
        if ("waw".equalsIgnoreCase(r))    return "badge badge-waw";
        if ("aleph".equalsIgnoreCase(r))  return "badge badge-aleph";
        return "badge";
    }

    private String attackBadge(String t) {
        if (t == null) return "badge";
        if ("black".equalsIgnoreCase(t)) return "badge badge-black";
        if ("white".equalsIgnoreCase(t)) return "badge badge-white";
        if ("red".equalsIgnoreCase(t))   return "badge badge-red";
        if ("pale".equalsIgnoreCase(t))  return "badge badge-pale";
        return "badge";
    }

    private String safe(String s) { return s != null ? s : "—"; }

    private String trunc(String s, int n) {
        if (s == null) return "—";
        return s.length() > n ? s.substring(0, n) + "…" : s;
    }
%>
<%
    AbnormalityDAO dao = new AbnormalityDAO();
    List<Abnormality> lista = new ArrayList<>();
    String errMsg = "";
    try {
        lista = dao.listarTodos();
    } catch (Exception e) {
        errMsg = e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Anormalidades | Lobotomy Corporation Wiki</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>☣</text></svg>">
</head>
<body>

<header class="site-header">
  <div class="header-inner">
    <a href="index.jsp" class="logo">
      <div class="logo-icon">☣</div>
      <div>
        <div class="logo-text">Lobotomy Corp.</div>
        <div class="logo-sub">Abnormality Database</div>
      </div>
    </a>
    <nav class="main-nav">
      <a href="index.jsp">Início</a>
      <a href="listar.jsp" class="active">Anormalidades</a>
      <a href="filtrar.jsp">Filtrar</a>
      <a href="form.jsp">Adicionar</a>
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

  <% if (!errMsg.isEmpty()) { %>
    <div class="alert alert-error">Erro de ligação à base de dados: <%= errMsg %></div>
  <% } %>

  <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:12px;">
    <p style="color:var(--text-muted);font-size:0.85rem;">Listagem completa ordenada por nome</p>
    <div style="display:flex;gap:10px;">
      <a href="filtrar.jsp" class="btn btn-secondary btn-sm">⚙ Filtrar</a>
      <a href="form.jsp" class="btn btn-primary btn-sm">＋ Adicionar</a>
    </div>
  </div>

  <% if (lista.isEmpty() && errMsg.isEmpty()) { %>
    <div class="alert alert-info">
      Nenhuma anormalidade encontrada na base de dados.
      <a href="form.jsp" style="color:var(--accent-yellow)">Adicionar o primeiro registo →</a>
    </div>
  <% } else if (!lista.isEmpty()) { %>

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
          <th>Benefício</th>
          <th>Descrição</th>
          <th>Acções</th>
        </tr>
      </thead>
      <tbody>
        <% for (Abnormality a : lista) { %>
        <tr>
          <td class="mono"><%= a.getId() %></td>
          <td><strong style="color:var(--accent-white)"><%= safe(a.getNome()) %></strong></td>
          <td class="mono"><%= safe(a.getCodigo()) %></td>
          <td><span class="<%= riskBadge(a.getRiskLevel()) %>"><%= safe(a.getRiskLevel()) %></span></td>
          <td><span class="<%= attackBadge(a.getAttackType()) %>"><%= safe(a.getAttackType()) %></span></td>
          <td class="mono"><%= a.getEboxes() %></td>
          <td style="text-align:center"><%= a.isFacilityBenefit() ? "✓" : "—" %></td>
          <td style="max-width:260px;color:var(--text-muted);font-size:0.85rem;"><%= trunc(a.getDescricao(), 80) %></td>
          <td>
            <div class="actions-cell">
              <a href="form.jsp?editId=<%= a.getId() %>" class="btn btn-secondary btn-sm">✎ Editar</a>
              <form method="post" action="form.jsp" style="display:inline"
                    onsubmit="return confirm('Apagar este registo?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= a.getId() %>">
                <button type="submit" class="btn btn-danger btn-sm">✗</button>
              </form>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>

  <!-- CARD GRID VIEW -->
  <div class="divider"></div>
  <div class="section-header" style="margin-top:40px;">
    <h2 class="section-title">Vista em Grelha</h2>
  </div>
  <div class="card-grid">
    <% for (Abnormality a : lista) { %>
    <div class="card">
      <div class="card-header">
        <div>
          <div class="card-title"><%= safe(a.getNome()) %></div>
          <div class="card-code"><%= safe(a.getCodigo()) %></div>
        </div>
        <span class="<%= riskBadge(a.getRiskLevel()) %>"><%= safe(a.getRiskLevel()) %></span>
      </div>
      <div class="card-body"><%= trunc(a.getDescricao(), 120) %></div>
      <div class="card-footer">
        <span class="<%= attackBadge(a.getAttackType()) %>"><%= safe(a.getAttackType()) %></span>
        <% if (a.isFacilityBenefit()) { %>
          <span class="badge" style="color:var(--accent-yellow);border-color:rgba(245,197,24,0.4)">✦ Benefício</span>
        <% } %>
        <div style="flex:1"></div>
        <a href="form.jsp?editId=<%= a.getId() %>" class="btn btn-secondary btn-sm">✎ Editar</a>
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
      <p style="font-size:0.82rem;color:var(--text-dim);line-height:1.7;">
        Base de dados enciclopédica de todas as Anormalidades do jogo Lobotomy Corporation.
      </p>
    </div>
    <div class="footer-col">
      <h4>Navegação</h4>
      <a href="index.jsp">Página Inicial</a>
      <a href="listar.jsp">Listar Anormalidades</a>
      <a href="filtrar.jsp">Filtrar por Critério</a>
      <a href="form.jsp">Adicionar Nova</a>
    </div>
    <div class="footer-col">
      <h4>Níveis de Risco</h4>
      <a href="filtrar.jsp?riskLevel=Zayin">Zayin — Baixo Risco</a>
      <a href="filtrar.jsp?riskLevel=Teth">Teth — Moderado</a>
      <a href="filtrar.jsp?riskLevel=He">He — Alto Risco</a>
      <a href="filtrar.jsp?riskLevel=Waw">Waw — Muito Alto</a>
      <a href="filtrar.jsp?riskLevel=Aleph">Aleph — Extremo</a>
    </div>
  </div>
  <div class="footer-bottom">
    <p>© 2026 — Lobotomy Corporation Wiki — Projeto Académico</p>
    <p>JSP + MySQL</p>
  </div>
</footer>

</body>
</html>

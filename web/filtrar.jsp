<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.AbnormalityDAO, model.Abnormality, java.util.*" %>
<%!
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

    private String safe(String s)  { return s != null ? s : "—"; }
    private String trunc(String s, int n) {
        if (s == null) return "—";
        return s.length() > n ? s.substring(0, n) + "…" : s;
    }
    private String sel(String cur, String val) {
        return (cur != null && cur.equals(val)) ? "selected" : "";
    }
%>
<%
    String fNome    = request.getParameter("nome")            != null ? request.getParameter("nome")            : "";
    String fRisk    = request.getParameter("riskLevel")       != null ? request.getParameter("riskLevel")       : "";
    String fAttack  = request.getParameter("attackType")      != null ? request.getParameter("attackType")      : "";
    String fBenefit = request.getParameter("facilityBenefit") != null ? request.getParameter("facilityBenefit") : "";
    String fMinEbox = request.getParameter("minEboxes")       != null ? request.getParameter("minEboxes")       : "";
    String fMaxEbox = request.getParameter("maxEboxes")       != null ? request.getParameter("maxEboxes")       : "";

    boolean hasFilter = !fNome.isBlank() || !fRisk.isBlank() || !fAttack.isBlank()
                     || !fBenefit.isBlank() || !fMinEbox.isBlank() || !fMaxEbox.isBlank();

    List<Abnormality> resultados = new ArrayList<>();
    String errMsg = "";
    if (hasFilter) {
        try {
            AbnormalityDAO dao = new AbnormalityDAO();
            resultados = dao.filtrar(
                fNome.isBlank()    ? null : fNome,
                fRisk.isBlank()    ? null : fRisk,
                fAttack.isBlank()  ? null : fAttack,
                fBenefit.isBlank() ? null : fBenefit,
                fMinEbox.isBlank() ? null : fMinEbox,
                fMaxEbox.isBlank() ? null : fMaxEbox
            );
        } catch (Exception e) {
            errMsg = e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Filtrar Anormalidades | Lobotomy Corporation Wiki</title>
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
      <a href="listar.jsp">Anormalidades</a>
      <a href="filtrar.jsp" class="active">Filtrar</a>
      <a href="form.jsp">Adicionar</a>
    </nav>
  </div>
</header>

<div class="page-header">
  <div class="container">
    <h1>Filtrar Anormalidades</h1>
    <p>Pesquisa avançada por múltiplos critérios cumulativos</p>
  </div>
</div>

<div class="container">

  <!-- PAINEL DE FILTROS -->
  <div class="filter-panel">
    <form method="get" action="filtrar.jsp">
      <div class="filter-grid">

        <div class="form-group">
          <label class="form-label">Nome</label>
          <input type="text" name="nome" class="form-control"
                 placeholder="Pesquisar por nome..."
                 value="<%= fNome %>">
        </div>

        <div class="form-group">
          <label class="form-label">Nível de Risco</label>
          <select name="riskLevel" class="form-control">
            <option value="">— Todos —</option>
            <option value="Zayin"  <%= sel(fRisk,"Zayin")  %>>Zayin</option>
            <option value="Teth"   <%= sel(fRisk,"Teth")   %>>Teth</option>
            <option value="He"     <%= sel(fRisk,"He")     %>>He</option>
            <option value="Waw"    <%= sel(fRisk,"Waw")    %>>Waw</option>
            <option value="Aleph"  <%= sel(fRisk,"Aleph")  %>>Aleph</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Tipo de Ataque</label>
          <select name="attackType" class="form-control">
            <option value="">— Todos —</option>
            <option value="Black" <%= sel(fAttack,"Black") %>>Black</option>
            <option value="White" <%= sel(fAttack,"White") %>>White</option>
            <option value="Red"   <%= sel(fAttack,"Red")   %>>Red</option>
            <option value="Pale"  <%= sel(fAttack,"Pale")  %>>Pale</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Benefício para a Instalação</label>
          <select name="facilityBenefit" class="form-control">
            <option value="">— Todos —</option>
            <option value="1" <%= sel(fBenefit,"1") %>>Sim — Tem benefício</option>
            <option value="0" <%= sel(fBenefit,"0") %>>Não tem benefício</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">E-Boxes Mínimo</label>
          <input type="number" name="minEboxes" class="form-control"
                 placeholder="0" min="0" value="<%= fMinEbox %>">
        </div>

        <div class="form-group">
          <label class="form-label">E-Boxes Máximo</label>
          <input type="number" name="maxEboxes" class="form-control"
                 placeholder="999" min="0" value="<%= fMaxEbox %>">
        </div>

      </div>
      <div class="filter-actions">
        <button type="submit" class="btn btn-primary">⚙ Aplicar Filtros</button>
        <a href="filtrar.jsp" class="btn btn-secondary">✕ Limpar</a>
        <% if (hasFilter) { %>
          <span style="color:var(--text-muted);font-size:0.8rem;margin-left:8px;">
            <%= resultados.size() %> resultado(s) encontrado(s)
          </span>
        <% } %>
      </div>
    </form>
  </div>

  <% if (!errMsg.isEmpty()) { %>
    <div class="alert alert-error">Erro: <%= errMsg %></div>
  <% } %>

  <!-- RESULTADOS -->
  <% if (hasFilter) { %>
    <% if (resultados.isEmpty()) { %>
      <div class="alert alert-info">
        Nenhuma anormalidade encontrada com os critérios seleccionados.
        <a href="filtrar.jsp" style="color:var(--accent-yellow)">Limpar filtros →</a>
      </div>
    <% } else { %>

      <!-- Tags de filtros activos -->
      <div style="margin-bottom:20px;display:flex;gap:8px;flex-wrap:wrap;align-items:center;">
        <span style="font-family:var(--font-mono);font-size:0.7rem;color:var(--text-muted);letter-spacing:1px;">FILTROS ACTIVOS:</span>
        <% if (!fNome.isBlank())    { %><span class="badge badge-teth">Nome: <%= fNome %></span><% } %>
        <% if (!fRisk.isBlank())    { %><span class="<%= riskBadge(fRisk) %>">Risco: <%= fRisk %></span><% } %>
        <% if (!fAttack.isBlank())  { %><span class="<%= attackBadge(fAttack) %>">Ataque: <%= fAttack %></span><% } %>
        <% if (!fBenefit.isBlank()) { %><span class="badge" style="color:var(--accent-yellow);border-color:rgba(245,197,24,.4)">Benefício: <%= "1".equals(fBenefit) ? "Sim" : "Não" %></span><% } %>
        <% if (!fMinEbox.isBlank()) { %><span class="badge badge-teth">E-Box ≥ <%= fMinEbox %></span><% } %>
        <% if (!fMaxEbox.isBlank()) { %><span class="badge badge-teth">E-Box ≤ <%= fMaxEbox %></span><% } %>
      </div>

      <!-- Tabela de resultados -->
      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>#</th>
              <th>Nome</th>
              <th>Código</th>
              <th>Nível de Risco</th>
              <th>Tipo Ataque</th>
              <th>Dano</th>
              <th>E-Boxes</th>
              <th>Benefício</th>
              <th>Qliphoth</th>
              <th>Descrição</th>
              <th>Acções</th>
            </tr>
          </thead>
          <tbody>
            <% for (Abnormality a : resultados) { %>
            <tr>
              <td class="mono"><%= a.getId() %></td>
              <td><strong style="color:var(--accent-white)"><%= safe(a.getNome()) %></strong></td>
              <td class="mono"><%= safe(a.getCodigo()) %></td>
              <td><span class="<%= riskBadge(a.getRiskLevel()) %>"><%= safe(a.getRiskLevel()) %></span></td>
              <td><span class="<%= attackBadge(a.getAttackType()) %>"><%= safe(a.getAttackType()) %></span></td>
              <td class="mono"><%= safe(a.getAttackDamage()) %></td>
              <td class="mono"><%= a.getEboxes() %></td>
              <td style="text-align:center"><%= a.isFacilityBenefit() ? "✓" : "—" %></td>
              <td class="mono"><%= safe(a.getQliphothCounter()) %></td>
              <td style="max-width:220px;color:var(--text-muted);font-size:0.82rem;"><%= trunc(a.getDescricao(), 70) %></td>
              <td>
                <a href="form.jsp?editId=<%= a.getId() %>" class="btn btn-secondary btn-sm">✎ Editar</a>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>

      <!-- Vista em Grelha -->
      <div class="divider"></div>
      <div class="section-header" style="margin-top:20px;">
        <h2 class="section-title">Vista em Grelha — <%= resultados.size() %> resultado(s)</h2>
      </div>
      <div class="card-grid">
        <% for (Abnormality a : resultados) { %>
        <div class="card">
          <div class="card-header">
            <div>
              <div class="card-title"><%= safe(a.getNome()) %></div>
              <div class="card-code"><%= safe(a.getCodigo()) %></div>
            </div>
            <span class="<%= riskBadge(a.getRiskLevel()) %>"><%= safe(a.getRiskLevel()) %></span>
          </div>
          <div class="card-body"><%= trunc(a.getDescricao(), 110) %></div>
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
  <% } else { %>
    <div class="alert alert-info">
      Seleciona um ou mais filtros acima e clica em <strong>Aplicar Filtros</strong> para pesquisar.
    </div>
  <% } %>

</div>

<footer class="site-footer">
  <div class="footer-inner">
    <div class="footer-col">
      <h4>Filtros Rápidos</h4>
      <a href="filtrar.jsp?riskLevel=Zayin">Zayin</a>
      <a href="filtrar.jsp?riskLevel=Teth">Teth</a>
      <a href="filtrar.jsp?riskLevel=He">He</a>
      <a href="filtrar.jsp?riskLevel=Waw">Waw</a>
      <a href="filtrar.jsp?riskLevel=Aleph">Aleph</a>
    </div>
    <div class="footer-col">
      <h4>Navegação</h4>
      <a href="index.jsp">Página Inicial</a>
      <a href="listar.jsp">Listar Anormalidades</a>
      <a href="form.jsp">Adicionar Nova</a>
    </div>
  </div>
  <div class="footer-bottom">
    <p>© 2026 — Lobotomy Corporation Wiki — Projeto Académico</p>
    <p>JSP + MySQL</p>
  </div>
</footer>

</body>
</html>

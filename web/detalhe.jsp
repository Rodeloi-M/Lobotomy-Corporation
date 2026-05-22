<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.AbnormalityDAO,dao.EgoEquipmentDAO,dao.ObservationDAO,dao.WorkProbabilityDAO" %>
<%@ page import="model.Abnormality,model.EgoEquipment,model.Observation,model.WorkProbability" %>
<%@ page import="java.util.List" %>
<%!
    private String safe(String s) { return (s != null && !s.isBlank()) ? s : "—"; }
    private String riskClass(String r) {
        if (r == null) return "badge";
        if ("Zayin".equalsIgnoreCase(r))  return "badge badge-zayin";
        if ("Teth".equalsIgnoreCase(r))   return "badge badge-teth";
        if ("He".equalsIgnoreCase(r))     return "badge badge-he";
        if ("Waw".equalsIgnoreCase(r))    return "badge badge-waw";
        if ("Aleph".equalsIgnoreCase(r))  return "badge badge-aleph";
        return "badge";
    }
    private String attackClass(String t) {
        if (t == null) return "badge";
        if ("Black".equalsIgnoreCase(t)) return "badge badge-black";
        if ("White".equalsIgnoreCase(t)) return "badge badge-white";
        if ("Red".equalsIgnoreCase(t))   return "badge badge-red";
        if ("Pale".equalsIgnoreCase(t))  return "badge badge-pale";
        return "badge";
    }
    private String moodClass(int boxes, Abnormality a) {
        // returns "good", "normal" or "bad"
        try {
            String good = a.getGoodMood();
            if (good != null && !good.isBlank()) {
                int min = Integer.parseInt(good.split("-")[0].trim());
                if (boxes >= min) return "good";
            }
            String bad = a.getBadMood();
            if (bad != null && !bad.isBlank()) {
                int max = Integer.parseInt(bad.split("-")[1].trim());
                if (boxes <= max) return "bad";
            }
        } catch (Exception ignored) {}
        return "normal";
    }
    private String workRateClass(String rate) {
        if (rate == null) return "";
        if ("Very High".equalsIgnoreCase(rate))   return "rate-very-high";
        if ("High".equalsIgnoreCase(rate))        return "rate-high";
        if ("Common".equalsIgnoreCase(rate))      return "rate-common";
        if ("Low".equalsIgnoreCase(rate))         return "rate-low";
        if ("Very Low".equalsIgnoreCase(rate))    return "rate-very-low";
        return "";
    }
%>
<%
    int id = 0;
    try { id = Integer.parseInt(request.getParameter("id")); }
    catch (Exception e) { response.sendRedirect("listar.jsp"); return; }

    AbnormalityDAO dao = new AbnormalityDAO();
    Abnormality a = null;
    try { a = dao.buscarPorId(id); } catch (Exception e) { /* ignore */ }

    if (a == null) { response.sendRedirect("listar.jsp"); return; }

    List<EgoEquipment>     egos  = null;
    List<Observation>      obs   = null;
    List<WorkProbability>  works = null;
    try {
        egos  = new EgoEquipmentDAO().buscarPorAbnormality(id);
        obs   = new ObservationDAO().buscarPorAbnormality(id);
        works = new WorkProbabilityDAO().buscarPorAbnormality(id);
    } catch (Exception e) { /* tabelas podem estar vazias */ }
    if (egos  == null) egos  = new java.util.ArrayList<>();
    if (obs   == null) obs   = new java.util.ArrayList<>();
    if (works == null) works = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= safe(a.getNome()) %> | Lobotomy Corporation Wiki</title>
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

<!-- BREADCRUMB -->
<div class="breadcrumb-bar">
  <div class="container">
    <a href="index.html">Início</a>
    <span class="bc-sep">›</span>
    <a href="listar.jsp">Anormalidades</a>
    <span class="bc-sep">›</span>
    <span><%= safe(a.getNome()) %></span>
  </div>
</div>

<div class="container detail-page">

  <!-- ═══ INFOBOX (topo — estilo Fandom) ═══════════════════ -->
  <div class="infobox-header">
    <div class="infobox-title-row">
      <h1 class="infobox-name"><%= safe(a.getNome()) %></h1>
      <div class="infobox-badges">
        <span class="<%= riskClass(a.getRiskLevel()) %>"><%= safe(a.getRiskLevel()) %></span>
        <% if (a.isFacilityBenefit()) { %>
          <span class="badge" style="color:var(--accent-yellow);border-color:rgba(245,197,24,.4)">✦ Benefício</span>
        <% } %>
      </div>
    </div>
    <div class="infobox-code">
      <span class="mono-tag"><%= safe(a.getCodigo()) %></span>
    </div>
  </div>

  <div class="detail-layout">

    <!-- LEFT: infobox card (lado direito no fandom mas esquerdo aqui) -->
    <aside class="detail-infobox">
      <!-- Imagem -->
      <div class="infobox-image-wrap">
        <% if (a.getImagem() != null && !a.getImagem().isBlank()) { %>
          <img src="<%= a.getImagem() %>" alt="<%= safe(a.getNome()) %>" class="infobox-image">
        <% } else { %>
          <div class="infobox-image-placeholder">
            <img src="images/logo.svg" alt="L Corp" style="width:60px;opacity:.3">
            <p>Sem Imagem</p>
          </div>
        <% } %>
      </div>

      <!-- Stats table -->
      <table class="infobox-table">
        <tr><th colspan="2" class="infobox-section-head">Informação Básica</th></tr>
        <tr>
          <td class="ib-key">Código</td>
          <td class="ib-val mono-tag"><%= safe(a.getCodigo()) %></td>
        </tr>
        <tr>
          <td class="ib-key">Nível de Risco</td>
          <td class="ib-val"><span class="<%= riskClass(a.getRiskLevel()) %>"><%= safe(a.getRiskLevel()) %></span></td>
        </tr>
        <tr>
          <td class="ib-key">Tipo de Dano</td>
          <td class="ib-val"><span class="<%= attackClass(a.getAttackType()) %>"><%= safe(a.getAttackType()) %> (<%= safe(a.getAttackDamage()) %>)</span></td>
        </tr>
        <tr>
          <td class="ib-key">E-Boxes</td>
          <td class="ib-val"><span class="mono-tag"><%= a.getEboxes() %></span></td>
        </tr>
        <tr>
          <td class="ib-key">Qliphoth</td>
          <td class="ib-val"><span class="mono-tag"><%= safe(a.getQliphothCounter()) %></span></td>
        </tr>
        <tr>
          <td class="ib-key">Benefício</td>
          <td class="ib-val"><%= a.isFacilityBenefit() ? "✓ Sim" : "✗ Não" %></td>
        </tr>
        <tr><th colspan="2" class="infobox-section-head">Estados de Humor</th></tr>
        <tr>
          <td class="ib-key mood-good">😊 Bom</td>
          <td class="ib-val"><%= safe(a.getGoodMood()) %> E-Boxes</td>
        </tr>
        <tr>
          <td class="ib-key mood-normal">😐 Normal</td>
          <td class="ib-val"><%= safe(a.getNormalMood()) %> E-Boxes</td>
        </tr>
        <tr>
          <td class="ib-key mood-bad">😠 Mau</td>
          <td class="ib-val"><%= safe(a.getBadMood()) %> E-Boxes</td>
        </tr>
      </table>

      <!-- MOOD BAR -->
      <div class="mood-bar-wrap">
        <div class="mood-bar-label">MEDIDOR DE HUMOR</div>
        <div class="mood-bar">
          <div class="mood-seg mood-seg-bad"   title="Mau: <%= safe(a.getBadMood()) %>">BAD</div>
          <div class="mood-seg mood-seg-normal" title="Normal: <%= safe(a.getNormalMood()) %>">NORMAL</div>
          <div class="mood-seg mood-seg-good"  title="Bom: <%= safe(a.getGoodMood()) %>">GOOD</div>
        </div>
        <div class="mood-bar-vals">
          <span><%= safe(a.getBadMood()) %></span>
          <span><%= safe(a.getNormalMood()) %></span>
          <span><%= safe(a.getGoodMood()) %></span>
        </div>
      </div>

      <!-- ACÇÕES -->
      <div class="infobox-actions">
        <a href="form.jsp?editId=<%= a.getId() %>" class="btn btn-secondary btn-sm" style="width:100%;text-align:center">✎ Editar Registo</a>
      </div>
    </aside>

    <!-- RIGHT: conteúdo principal -->
    <main class="detail-content">

      <!-- FLAVOUR TEXT / quote -->
      <% if (a.getFlavourText() != null && !a.getFlavourText().isBlank()) { %>
      <blockquote class="flavour-quote">
        "<%= a.getFlavourText() %>"
      </blockquote>
      <% } %>

      <!-- DESCRIÇÃO -->
      <section class="detail-section">
        <h2 class="detail-section-title">Descrição</h2>
        <p class="detail-text"><%= safe(a.getDescricao()) %></p>
      </section>

      <!-- HABILIDADE -->
      <section class="detail-section">
        <h2 class="detail-section-title">Habilidade</h2>
        <div class="ability-block">
          <p class="detail-text"><%= safe(a.getAbility()) %></p>
        </div>
      </section>

      <!-- PROBABILIDADES DE TRABALHO -->
      <% if (!works.isEmpty()) { %>
      <section class="detail-section">
        <h2 class="detail-section-title">Preferências de Trabalho</h2>
        <div class="work-table-wrap">
          <table class="work-table">
            <thead>
              <tr>
                <th>Trabalho</th>
                <th>Nível I</th>
                <th>Nível II</th>
                <th>Nível III</th>
                <th>Nível IV</th>
                <th>Nível V</th>
              </tr>
            </thead>
            <tbody>
              <% for (WorkProbability wp : works) { %>
              <tr>
                <td class="work-type work-<%= wp.getWorkType() != null ? wp.getWorkType().toLowerCase() : "" %>">
                  <%= safe(wp.getWorkType()) %>
                </td>
                <td class="<%= workRateClass(wp.getLevel1()) %>"><%= safe(wp.getLevel1()) %></td>
                <td class="<%= workRateClass(wp.getLevel2()) %>"><%= safe(wp.getLevel2()) %></td>
                <td class="<%= workRateClass(wp.getLevel3()) %>"><%= safe(wp.getLevel3()) %></td>
                <td class="<%= workRateClass(wp.getLevel4()) %>"><%= safe(wp.getLevel4()) %></td>
                <td class="<%= workRateClass(wp.getLevel5()) %>"><%= safe(wp.getLevel5()) %></td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </section>
      <% } %>

      <!-- ORIGEM -->
      <% if (a.getOriginText() != null && !a.getOriginText().isBlank()) { %>
      <section class="detail-section">
        <h2 class="detail-section-title">Origem</h2>
        <p class="detail-text"><%= a.getOriginText() %></p>
      </section>
      <% } %>

      <!-- DETALHES -->
      <% if (a.getDetailsText() != null && !a.getDetailsText().isBlank()) { %>
      <section class="detail-section">
        <h2 class="detail-section-title">Detalhes</h2>

        <!-- OBSERVATION LEVELS -->
        <% if (!obs.isEmpty()) { %>
        <div class="obs-levels">
          <h3 class="obs-title">Níveis de Observação</h3>
          <% for (Observation o : obs) { %>
          <div class="obs-level-item">
            <div class="obs-level-num">Nível <%= o.getLevelNumber() %></div>
            <div class="obs-level-bonus"><%= safe(o.getBonus()) %></div>
            <div class="obs-unlock-text"><%= safe(o.getUnlockText()) %></div>
          </div>
          <% } %>
        </div>
        <% } %>

        <p class="detail-text"><%= a.getDetailsText() %></p>
      </section>
      <% } %>

      <!-- EGO EQUIPMENT -->
      <% if (!egos.isEmpty()) { %>
      <section class="detail-section">
        <h2 class="detail-section-title">Equipamento E.G.O.</h2>
        <div class="ego-grid">
          <% for (EgoEquipment e : egos) { %>
          <div class="ego-card">
            <div class="ego-card-head">
              <span class="ego-name"><%= safe(e.getWeaponName()) %></span>
              <span class="<%= riskClass(e.getGrade()) %>"><%= safe(e.getGrade()) %></span>
            </div>
            <table class="ego-stats">
              <% if (e.getDamage() != null && !e.getDamage().isBlank() && !"—".equals(e.getDamage())) { %>
              <tr><td class="ego-key">Dano</td><td><%= e.getDamage() %></td></tr>
              <% } %>
              <% if (e.getAttackSpeed() != null && !e.getAttackSpeed().isBlank() && !"—".equals(e.getAttackSpeed())) { %>
              <tr><td class="ego-key">Velocidade</td><td><%= e.getAttackSpeed() %></td></tr>
              <% } %>
              <% if (e.getRangeType() != null && !e.getRangeType().isBlank() && !"—".equals(e.getRangeType())) { %>
              <tr><td class="ego-key">Alcance</td><td><%= e.getRangeType() %></td></tr>
              <% } %>
              <tr><td class="ego-key">Custo</td><td class="mono-tag"><%= e.getCost() %> PE</td></tr>
              <tr><td class="ego-key">Obs. Nível</td><td class="mono-tag"><%= e.getObservationLevel() %></td></tr>
            </table>
            <% if (e.getSpecialInfo() != null && !e.getSpecialInfo().isBlank()) { %>
            <p class="ego-info"><%= e.getSpecialInfo() %></p>
            <% } %>
          </div>
          <% } %>
        </div>
      </section>
      <% } %>

      <!-- HISTÓRIA / STORY -->
      <% if (a.getStory() != null && !a.getStory().isBlank()) { %>
      <section class="detail-section">
        <h2 class="detail-section-title">História</h2>
        <div class="lore-block"><%= a.getStory() %></div>
      </section>
      <% } %>

      <!-- TRIVIA -->
      <% if (a.getTrivia() != null && !a.getTrivia().isBlank()) { %>
      <section class="detail-section">
        <h2 class="detail-section-title">Trivia</h2>
        <p class="detail-text"><%= a.getTrivia() %></p>
      </section>
      <% } %>

      <!-- NAVEGAÇÃO ENTRE REGISTOS -->
      <div class="detail-nav">
        <a href="listar.jsp" class="btn btn-secondary">← Voltar à Lista</a>
        <a href="filtrar.jsp?riskLevel=<%= safe(a.getRiskLevel()) %>" class="btn btn-secondary">Ver todos <%= safe(a.getRiskLevel()) %></a>
        <a href="form.jsp?editId=<%= a.getId() %>" class="btn btn-primary">✎ Editar</a>
      </div>

    </main>
  </div>
</div>

<footer class="site-footer">
  <div class="footer-inner">
    <div class="footer-col">
      <h4>Lobotomy Corp. Wiki</h4>
      <p style="font-size:.82rem;color:var(--text-dim);line-height:1.7;">Base de dados de Anormalidades do jogo Lobotomy Corporation.</p>
    </div>
    <div class="footer-col">
      <h4>Navegação</h4>
      <a href="index.html">Página Inicial</a>
      <a href="listar.jsp">Listar Anormalidades</a>
      <a href="filtrar.jsp">Filtrar</a>
      <a href="form.jsp">Gestão CRUD</a>
    </div>
  </div>
  <div class="footer-bottom">
    <p>© 2026 — Lobotomy Corporation Wiki — Projeto Académico</p>
    <p>JSP + MySQL</p>
  </div>
</footer>
</body>
</html>

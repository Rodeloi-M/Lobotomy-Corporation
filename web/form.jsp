<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.AbnormalityDAO, model.Abnormality" %>
<%!
    private String v(String val)  { return val != null ? val : ""; }
    private String optSel(String current, String option) {
        return (current != null && current.equals(option)) ? "selected" : "";
    }
    private boolean checked(boolean val) { return val; }
%>
<%
    AbnormalityDAO dao = new AbnormalityDAO();
    String msg      = "";
    String msgType  = "info";
    String action   = request.getParameter("action");
    int    savedId  = 0; // id do registo após save, para recarregar em modo edição

    // ── DELETE ─────────────────────────────────────────────────────
    if ("delete".equals(action)) {
        try {
            int delId = Integer.parseInt(request.getParameter("id"));
            dao.apagar(delId);
            response.sendRedirect("listar.jsp?msg=deleted");
            return;
        } catch (Exception e) {
            msg     = "✗ Erro ao apagar: " + e.getMessage();
            msgType = "error";
        }
    }

    // ── SAVE (INSERT ou UPDATE) ─────────────────────────────────────
    else if ("save".equals(action)) {
        try {
            Abnormality a = new Abnormality();

            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isBlank()) {
                a.setId(Integer.parseInt(idStr.trim()));
            }

            a.setNome(request.getParameter("nome"));
            a.setCodigo(request.getParameter("codigo"));

            String eboxStr = request.getParameter("eboxes");
            a.setEboxes((eboxStr != null && !eboxStr.isBlank()) ? Integer.parseInt(eboxStr.trim()) : 0);

            a.setAttackType(request.getParameter("attackType"));
            a.setAttackDamage(request.getParameter("attackDamage"));
            a.setRiskLevel(request.getParameter("riskLevel"));
            a.setFacilityBenefit("on".equals(request.getParameter("facilityBenefit")));
            a.setGoodMood(request.getParameter("goodMood"));
            a.setNormalMood(request.getParameter("normalMood"));
            a.setBadMood(request.getParameter("badMood"));
            a.setQliphothCounter(request.getParameter("qliphothCounter"));
            a.setDescricao(request.getParameter("descricao"));
            a.setAbility(request.getParameter("ability"));
            a.setOriginText(request.getParameter("originText"));
            a.setDetailsText(request.getParameter("detailsText"));
            a.setStory(request.getParameter("story"));
            a.setFlavourText(request.getParameter("flavourText"));
            a.setTrivia(request.getParameter("trivia"));
            a.setImagem(request.getParameter("imagem"));

            if (a.getId() > 0) {
                dao.atualizar(a);
                savedId = a.getId();
                msg     = "✓ Anormalidade <strong>" + v(a.getNome()) + "</strong> actualizada com sucesso.";
            } else {
                dao.inserir(a);
                // obter o id gerado
                java.util.List<model.Abnormality> todos = dao.listarTodos();
                // último inserido — buscar pelo nome
                for (model.Abnormality x : todos) {
                    if (v(a.getNome()).equals(v(x.getNome()))) savedId = x.getId();
                }
                msg = "✓ Anormalidade <strong>" + v(a.getNome()) + "</strong> inserida com sucesso.";
            }
            msgType = "success";
        } catch (Exception e) {
            msg     = "✗ Erro ao guardar: " + e.getMessage();
            msgType = "error";
        }
    }

    // ── CARREGAR REGISTO PARA EDIÇÃO ────────────────────────────────
    // Prioridade: savedId (após save) > editId (GET) > id (POST)
    Abnormality edit = null;
    String rawId = request.getParameter("editId");
    if (rawId == null || rawId.isBlank()) rawId = request.getParameter("id");
    if (savedId > 0) rawId = String.valueOf(savedId);

    if (rawId != null && !rawId.isBlank()) {
        try { edit = dao.buscarPorId(Integer.parseInt(rawId.trim())); }
        catch (Exception e) { /* ignorar */ }
    }
    boolean isEdit = (edit != null);
%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= isEdit ? "Editar: " + v(edit.getNome()) : "Nova Anormalidade" %> | Lobotomy Corporation Wiki</title>
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
      <a href="listar.jsp">Anormalidades</a>
      <a href="filtrar.jsp">Filtrar</a>
      <a href="form.jsp" class="active">Gestão</a>
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
    <% if (isEdit) { %>
      <a href="detalhe.jsp?id=<%= edit.getId() %>"><%= v(edit.getNome()) %></a>
      <span class="bc-sep">›</span>
      <span>Editar</span>
    <% } else { %>
      <span>Nova Anormalidade</span>
    <% } %>
  </div>
</div>

<div class="page-header">
  <div class="container">
    <h1><%= isEdit ? "Editar: " + v(edit.getNome()) : "Nova Anormalidade" %></h1>
    <p>
      <% if (isEdit) { %>
        Registo #<%= edit.getId() %> &nbsp;·&nbsp;
        <span class="<%= edit.getRiskLevel() != null ? "badge badge-"+edit.getRiskLevel().toLowerCase() : "badge" %>">
          <%= v(edit.getRiskLevel()) %>
        </span>
        &nbsp;·&nbsp; <a href="detalhe.jsp?id=<%= edit.getId() %>" style="color:var(--accent-cyan)">Ver página completa →</a>
      <% } else { %>
        Preencha os campos abaixo e clique em Inserir para adicionar à base de dados.
      <% } %>
    </p>
  </div>
</div>

<div class="container" style="padding-bottom:60px;">

  <% if (!msg.isEmpty()) { %>
    <div class="alert alert-<%= msgType %>"><%= msg %></div>
  <% } %>

  <!-- ══ FORMULÁRIO PRINCIPAL ═══════════════════════════════════ -->
  <div class="form-panel">
    <form method="post" action="form.jsp">
      <input type="hidden" name="action" value="save">
      <% if (isEdit) { %>
        <input type="hidden" name="id" value="<%= edit.getId() %>">
      <% } %>

      <!-- ▸ IDENTIFICAÇÃO -->
      <div class="form-section-title">▸ Identificação</div>
      <div class="form-grid">

        <div class="form-group">
          <label class="form-label">Nome *</label>
          <input type="text" name="nome" class="form-control" required
                 placeholder="ex: One Sin and Hundreds of Good Deeds"
                 value="<%= isEdit ? v(edit.getNome()) : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">Código</label>
          <input type="text" name="codigo" class="form-control"
                 placeholder="ex: O-03-03"
                 value="<%= isEdit ? v(edit.getCodigo()) : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">E-Boxes</label>
          <input type="number" name="eboxes" class="form-control" min="0" max="99"
                 placeholder="10"
                 value="<%= isEdit ? edit.getEboxes() : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">Nível de Risco *</label>
          <select name="riskLevel" class="form-control" required>
            <option value="">— Selecionar —</option>
            <option value="Zayin" <%= isEdit ? optSel(edit.getRiskLevel(),"Zayin") : "" %>>Zayin</option>
            <option value="Teth"  <%= isEdit ? optSel(edit.getRiskLevel(),"Teth")  : "" %>>Teth</option>
            <option value="He"    <%= isEdit ? optSel(edit.getRiskLevel(),"He")    : "" %>>He</option>
            <option value="Waw"   <%= isEdit ? optSel(edit.getRiskLevel(),"Waw")   : "" %>>Waw</option>
            <option value="Aleph" <%= isEdit ? optSel(edit.getRiskLevel(),"Aleph") : "" %>>Aleph</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">URL da Imagem</label>
          <input type="text" name="imagem" class="form-control"
                 placeholder="https://... ou caminho relativo"
                 value="<%= isEdit ? v(edit.getImagem()) : "" %>">
        </div>

      </div>

      <!-- ▸ COMBATE -->
      <div class="form-section-title" style="margin-top:28px;">▸ Combate</div>
      <div class="form-grid">

        <div class="form-group">
          <label class="form-label">Tipo de Ataque</label>
          <select name="attackType" class="form-control">
            <option value="">— Selecionar —</option>
            <option value="Black" <%= isEdit ? optSel(edit.getAttackType(),"Black") : "" %>>Black</option>
            <option value="White" <%= isEdit ? optSel(edit.getAttackType(),"White") : "" %>>White</option>
            <option value="Red"   <%= isEdit ? optSel(edit.getAttackType(),"Red")   : "" %>>Red</option>
            <option value="Pale"  <%= isEdit ? optSel(edit.getAttackType(),"Pale")  : "" %>>Pale</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Dano</label>
          <input type="text" name="attackDamage" class="form-control"
                 placeholder="ex: 1-2"
                 value="<%= isEdit ? v(edit.getAttackDamage()) : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">Contador Qliphoth</label>
          <input type="text" name="qliphothCounter" class="form-control"
                 placeholder="ex: 4  ou  X (sem counter)"
                 value="<%= isEdit ? v(edit.getQliphothCounter()) : "" %>">
        </div>

        <div class="form-group" style="justify-content:flex-end;padding-top:20px;">
          <label style="display:flex;align-items:center;gap:10px;cursor:pointer;color:var(--text-muted);font-size:.9rem;letter-spacing:1px;user-select:none;">
            <input type="checkbox" name="facilityBenefit"
                   <%= (isEdit && edit.isFacilityBenefit()) ? "checked" : "" %>
                   style="accent-color:var(--accent-yellow);width:16px;height:16px;">
            ✦ Benefício para a Instalação
          </label>
        </div>

      </div>

      <!-- ▸ ESTADOS DE HUMOR -->
      <div class="form-section-title" style="margin-top:28px;">▸ Estados de Humor</div>
      <div class="form-grid">

        <div class="form-group">
          <label class="form-label" style="color:#27ae60">😊 Mood Bom (Good)</label>
          <input type="text" name="goodMood" class="form-control"
                 placeholder="ex: 8-10"
                 value="<%= isEdit ? v(edit.getGoodMood()) : "" %>"
                 style="border-color:rgba(39,174,96,.3)">
        </div>

        <div class="form-group">
          <label class="form-label" style="color:#f39c12">😐 Mood Normal</label>
          <input type="text" name="normalMood" class="form-control"
                 placeholder="ex: 4-7"
                 value="<%= isEdit ? v(edit.getNormalMood()) : "" %>"
                 style="border-color:rgba(243,156,18,.3)">
        </div>

        <div class="form-group">
          <label class="form-label" style="color:#e74c3c">😠 Mood Mau (Bad)</label>
          <input type="text" name="badMood" class="form-control"
                 placeholder="ex: 0-3"
                 value="<%= isEdit ? v(edit.getBadMood()) : "" %>"
                 style="border-color:rgba(231,76,60,.3)">
        </div>

      </div>

      <!-- ▸ DESCRIÇÃO E LORE -->
      <div class="form-section-title" style="margin-top:28px;">▸ Descrição e Lore</div>
      <div class="form-grid">

        <div class="form-group full-width">
          <label class="form-label">Descrição Geral</label>
          <textarea name="descricao" class="form-control" rows="4"
                    placeholder="Descrição geral da Anormalidade..."><%= isEdit ? v(edit.getDescricao()) : "" %></textarea>
        </div>

        <div class="form-group full-width">
          <label class="form-label">Habilidade / Ability</label>
          <textarea name="ability" class="form-control" rows="4"
                    placeholder="Descrição da habilidade especial..."><%= isEdit ? v(edit.getAbility()) : "" %></textarea>
        </div>

        <div class="form-group">
          <label class="form-label">Texto de Origem</label>
          <textarea name="originText" class="form-control" rows="3"
                    placeholder="Origem da Anormalidade..."><%= isEdit ? v(edit.getOriginText()) : "" %></textarea>
        </div>

        <div class="form-group">
          <label class="form-label">Detalhes Técnicos</label>
          <textarea name="detailsText" class="form-control" rows="3"
                    placeholder="Informações de gestão..."><%= isEdit ? v(edit.getDetailsText()) : "" %></textarea>
        </div>

        <div class="form-group">
          <label class="form-label">História / Story</label>
          <textarea name="story" class="form-control" rows="4"
                    placeholder="História de fundo / lore..."><%= isEdit ? v(edit.getStory()) : "" %></textarea>
        </div>

        <div class="form-group">
          <label class="form-label">Flavour Text</label>
          <textarea name="flavourText" class="form-control" rows="3"
                    placeholder='"It feeds on the evil..."'><%= isEdit ? v(edit.getFlavourText()) : "" %></textarea>
        </div>

        <div class="form-group full-width">
          <label class="form-label">Trivia / Curiosidades</label>
          <textarea name="trivia" class="form-control" rows="3"
                    placeholder="Referências culturais, curiosidades..."><%= isEdit ? v(edit.getTrivia()) : "" %></textarea>
        </div>

      </div>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary">
          <%= isEdit ? "✎ Guardar Alterações" : "＋ Inserir Anormalidade" %>
        </button>
        <% if (isEdit) { %>
          <a href="detalhe.jsp?id=<%= edit.getId() %>" class="btn btn-secondary">👁 Ver Detalhe</a>
        <% } %>
        <a href="listar.jsp" class="btn btn-secondary">← Voltar à Lista</a>
        <% if (isEdit) { %>
          <a href="form.jsp" class="btn btn-secondary">＋ Novo Registo</a>
        <% } %>
      </div>
    </form>
  </div>

  <!-- ══ ZONA DE PERIGO (só em modo edição) ══════════════════════ -->
  <% if (isEdit) { %>
  <div class="form-panel" style="margin-top:20px;border-color:rgba(192,57,43,.35);">
    <div class="form-section-title" style="color:var(--accent-red);">⚠ Zona de Perigo</div>
    <p style="color:var(--text-muted);font-size:.9rem;margin-bottom:16px;">
      Esta acção é <strong style="color:var(--accent-red)">irreversível</strong>.
      O registo <em><%= v(edit.getNome()) %></em> será permanentemente apagado da base de dados.
    </p>
    <form method="post" action="form.jsp"
          onsubmit="return confirm('Tens a certeza que queres apagar \'' + '<%= v(edit.getNome()).replace("'","") %>' + '\'?\nEsta acção não pode ser desfeita.');">
      <input type="hidden" name="action" value="delete">
      <input type="hidden" name="id"     value="<%= edit.getId() %>">
      <button type="submit" class="btn btn-danger">✗ Apagar Permanentemente</button>
    </form>
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
      <a href="form.jsp">Nova Anormalidade</a>
    </div>
  </div>
  <div class="footer-bottom">
    <p>© 2026 — Lobotomy Corporation Wiki — Projeto Académico</p>
    <p>JSP + MySQL</p>
  </div>
</footer>
</body>
</html>

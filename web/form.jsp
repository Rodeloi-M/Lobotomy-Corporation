<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.AbnormalityDAO, model.Abnormality" %>
<%!
    private String v(String val) { return val != null ? val : ""; }

    private String optSel(String current, String option) {
        return (current != null && current.equals(option)) ? "selected" : "";
    }
%>
<%
    AbnormalityDAO dao = new AbnormalityDAO();
    String msg     = "";
    String msgType = "info";
    String action  = request.getParameter("action");

    // ── DELETE ─────────────────────────────────────────────────
    if ("delete".equals(action)) {
        try {
            int delId = Integer.parseInt(request.getParameter("id"));
            dao.apagar(delId);
            msg     = "✓ Anormalidade apagada com sucesso.";
            msgType = "success";
        } catch (Exception e) {
            msg     = "✗ Erro ao apagar: " + e.getMessage();
            msgType = "error";
        }
    }

    // ── SAVE (INSERT ou UPDATE) ────────────────────────────────
    else if ("save".equals(action)) {
        try {
            Abnormality a = new Abnormality();

            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isBlank()) {
                a.setId(Integer.parseInt(idStr));
            }

            a.setNome(request.getParameter("nome"));
            a.setCodigo(request.getParameter("codigo"));

            String eboxStr = request.getParameter("eboxes");
            a.setEboxes((eboxStr != null && !eboxStr.isBlank()) ? Integer.parseInt(eboxStr) : 0);

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
                msg = "✓ Anormalidade atualizada com sucesso.";
            } else {
                dao.inserir(a);
                msg = "✓ Anormalidade inserida com sucesso.";
            }
            msgType = "success";
        } catch (Exception e) {
            msg     = "✗ Erro ao guardar: " + e.getMessage();
            msgType = "error";
        }
    }

    // ── CARREGAR PARA EDIÇÃO ───────────────────────────────────
    Abnormality edit = null;
    String editId = request.getParameter("editId");
    if (editId != null && !editId.isBlank()) {
        try {
            edit = dao.buscarPorId(Integer.parseInt(editId));
        } catch (Exception e) { /* ignorar */ }
    }
%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestão de Anormalidades | Lobotomy Corporation Wiki</title>
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
      <a href="filtrar.jsp">Filtrar</a>
      <a href="form.jsp" class="active">Adicionar</a>
    </nav>
  </div>
</header>

<div class="page-header">
  <div class="container">
    <h1><%= edit != null ? "Editar Anormalidade" : "Nova Anormalidade" %></h1>
    <p><%= edit != null
           ? "A actualizar o registo #" + edit.getId() + " — " + (edit.getNome() != null ? edit.getNome() : "")
           : "Inserir um novo registo na base de dados" %></p>
  </div>
</div>

<div class="container">

  <% if (!msg.isEmpty()) { %>
    <div class="alert alert-<%= msgType %>"><%= msg %></div>
  <% } %>

  <!-- ── FORMULÁRIO PRINCIPAL ─────────────────────────────── -->
  <div class="form-panel">
    <form method="post" action="form.jsp">
      <input type="hidden" name="action" value="save">
      <% if (edit != null) { %>
        <input type="hidden" name="id" value="<%= edit.getId() %>">
      <% } %>

      <!-- BLOCO 1: Identificação -->
      <div class="form-section-title">▸ Identificação</div>
      <div class="form-grid">

        <div class="form-group">
          <label class="form-label">Nome *</label>
          <input type="text" name="nome" class="form-control" required
                 placeholder="ex: One Sin and Hundreds of Good Deeds"
                 value="<%= edit != null ? v(edit.getNome()) : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">Código</label>
          <input type="text" name="codigo" class="form-control"
                 placeholder="ex: O-01-57"
                 value="<%= edit != null ? v(edit.getCodigo()) : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">E-Boxes (Energia)</label>
          <input type="number" name="eboxes" class="form-control" min="0"
                 placeholder="0"
                 value="<%= edit != null ? edit.getEboxes() : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">Nível de Risco *</label>
          <select name="riskLevel" class="form-control" required>
            <option value="">— Selecionar —</option>
            <option value="Zayin" <%= edit != null ? optSel(edit.getRiskLevel(),"Zayin") : "" %>>Zayin</option>
            <option value="Teth"  <%= edit != null ? optSel(edit.getRiskLevel(),"Teth")  : "" %>>Teth</option>
            <option value="He"    <%= edit != null ? optSel(edit.getRiskLevel(),"He")    : "" %>>He</option>
            <option value="Waw"   <%= edit != null ? optSel(edit.getRiskLevel(),"Waw")   : "" %>>Waw</option>
            <option value="Aleph" <%= edit != null ? optSel(edit.getRiskLevel(),"Aleph") : "" %>>Aleph</option>
          </select>
        </div>

      </div>

      <!-- BLOCO 2: Combate -->
      <div class="form-section-title" style="margin-top:32px;">▸ Combate</div>
      <div class="form-grid">

        <div class="form-group">
          <label class="form-label">Tipo de Ataque</label>
          <select name="attackType" class="form-control">
            <option value="">— Selecionar —</option>
            <option value="Black" <%= edit != null ? optSel(edit.getAttackType(),"Black") : "" %>>Black</option>
            <option value="White" <%= edit != null ? optSel(edit.getAttackType(),"White") : "" %>>White</option>
            <option value="Red"   <%= edit != null ? optSel(edit.getAttackType(),"Red")   : "" %>>Red</option>
            <option value="Pale"  <%= edit != null ? optSel(edit.getAttackType(),"Pale")  : "" %>>Pale</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Dano de Ataque</label>
          <input type="text" name="attackDamage" class="form-control"
                 placeholder="ex: 50~70"
                 value="<%= edit != null ? v(edit.getAttackDamage()) : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">Contador Qliphoth</label>
          <input type="text" name="qliphothCounter" class="form-control"
                 placeholder="ex: 2"
                 value="<%= edit != null ? v(edit.getQliphothCounter()) : "" %>">
        </div>

        <div class="form-group" style="justify-content:flex-end;padding-top:10px;">
          <label style="display:flex;align-items:center;gap:10px;cursor:pointer;color:var(--text-muted);font-size:0.9rem;letter-spacing:1px;">
            <input type="checkbox" name="facilityBenefit"
                   <%= (edit != null && edit.isFacilityBenefit()) ? "checked" : "" %>
                   style="accent-color:var(--accent-yellow);width:16px;height:16px;">
            Benefício para a Instalação
          </label>
        </div>

      </div>

      <!-- BLOCO 3: Estados de Humor -->
      <div class="form-section-title" style="margin-top:32px;">▸ Estados de Humor</div>
      <div class="form-grid">

        <div class="form-group">
          <label class="form-label">Mood Bom (Good)</label>
          <input type="text" name="goodMood" class="form-control"
                 placeholder="ex: 0~80"
                 value="<%= edit != null ? v(edit.getGoodMood()) : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">Mood Normal</label>
          <input type="text" name="normalMood" class="form-control"
                 placeholder="ex: 0~50"
                 value="<%= edit != null ? v(edit.getNormalMood()) : "" %>">
        </div>

        <div class="form-group">
          <label class="form-label">Mood Mau (Bad)</label>
          <input type="text" name="badMood" class="form-control"
                 placeholder="ex: 0~20"
                 value="<%= edit != null ? v(edit.getBadMood()) : "" %>">
        </div>

      </div>

      <!-- BLOCO 4: Lore e Descrição -->
      <div class="form-section-title" style="margin-top:32px;">▸ Descrição e Lore</div>
      <div class="form-grid">

        <div class="form-group full-width">
          <label class="form-label">Descrição Geral</label>
          <textarea name="descricao" class="form-control" rows="4"
                    placeholder="Descrição geral da Anormalidade..."><%= edit != null ? v(edit.getDescricao()) : "" %></textarea>
        </div>

        <div class="form-group full-width">
          <label class="form-label">Habilidade / Ability</label>
          <textarea name="ability" class="form-control" rows="3"
                    placeholder="Descrição da habilidade especial..."><%= edit != null ? v(edit.getAbility()) : "" %></textarea>
        </div>

        <div class="form-group">
          <label class="form-label">Texto de Origem</label>
          <textarea name="originText" class="form-control" rows="3"
                    placeholder="Origem da Anormalidade..."><%= edit != null ? v(edit.getOriginText()) : "" %></textarea>
        </div>

        <div class="form-group">
          <label class="form-label">Detalhes Técnicos</label>
          <textarea name="detailsText" class="form-control" rows="3"
                    placeholder="Detalhes adicionais..."><%= edit != null ? v(edit.getDetailsText()) : "" %></textarea>
        </div>

        <div class="form-group">
          <label class="form-label">História / Story</label>
          <textarea name="story" class="form-control" rows="3"
                    placeholder="História de fundo..."><%= edit != null ? v(edit.getStory()) : "" %></textarea>
        </div>

        <div class="form-group">
          <label class="form-label">Flavour Text</label>
          <textarea name="flavourText" class="form-control" rows="3"
                    placeholder="Texto de sabor / citação literária..."><%= edit != null ? v(edit.getFlavourText()) : "" %></textarea>
        </div>

        <div class="form-group full-width">
          <label class="form-label">Trivia / Curiosidades</label>
          <textarea name="trivia" class="form-control" rows="3"
                    placeholder="Curiosidades e factos..."><%= edit != null ? v(edit.getTrivia()) : "" %></textarea>
        </div>

        <div class="form-group full-width">
          <label class="form-label">URL da Imagem</label>
          <input type="text" name="imagem" class="form-control"
                 placeholder="https://... ou caminho relativo (ex: images/abnormality.png)"
                 value="<%= edit != null ? v(edit.getImagem()) : "" %>">
        </div>

      </div>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary">
          <%= edit != null ? "✎ Actualizar Registo" : "＋ Inserir Anormalidade" %>
        </button>
        <a href="listar.jsp" class="btn btn-secondary">← Voltar à Lista</a>
        <% if (edit != null) { %>
          <a href="form.jsp" class="btn btn-secondary">＋ Novo Registo</a>
        <% } %>
      </div>
    </form>
  </div>

  <!-- ── ZONA DE PERIGO (só em modo edição) ────────────────── -->
  <% if (edit != null) { %>
  <div class="form-panel" style="margin-top:20px;border-color:rgba(192,57,43,0.35);">
    <div class="form-section-title" style="color:var(--accent-red);">▸ Zona de Perigo</div>
    <p style="color:var(--text-muted);font-size:0.9rem;margin-bottom:16px;">
      Esta acção é <strong style="color:var(--accent-red)">irreversível</strong>.
      O registo será permanentemente apagado da base de dados.
    </p>
    <form method="post" action="form.jsp"
          onsubmit="return confirm('Tens a certeza que queres apagar esta Anormalidade? Esta acção não pode ser desfeita.');">
      <input type="hidden" name="action" value="delete">
      <input type="hidden" name="id" value="<%= edit.getId() %>">
      <button type="submit" class="btn btn-danger">✗ Apagar este Registo Permanentemente</button>
    </form>
  </div>
  <% } %>

</div>

<footer class="site-footer">
  <div class="footer-inner">
    <div class="footer-col">
      <h4>Lobotomy Corp. Wiki</h4>
      <p style="font-size:0.82rem;color:var(--text-dim);line-height:1.7;">
        Base de dados de Anormalidades do jogo Lobotomy Corporation.
      </p>
    </div>
    <div class="footer-col">
      <h4>Navegação</h4>
      <a href="index.jsp">Página Inicial</a>
      <a href="listar.jsp">Listar Anormalidades</a>
      <a href="filtrar.jsp">Filtrar por Critério</a>
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

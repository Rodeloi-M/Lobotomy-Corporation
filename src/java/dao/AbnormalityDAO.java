package dao;

import model.Abnormality;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para operações CRUD na tabela `abnormality`.
 * Lobotomy Corporation Wiki — Projeto Académico
 */
public class AbnormalityDAO {

    // ─── INSERT ──────────────────────────────────────────────────────────────

    public boolean inserir(Abnormality a) throws SQLException {
        String sql = """
            INSERT INTO abnormality
              (nome, codigo, eboxes, attackType, attackDamage, riskLevel,
               facilityBenefit, goodMood, normalMood, badMood, qliphothCounter,
               descricao, ability, originText, detailsText, story, flavourText, trivia, imagem)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
            """;
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1,  a.getNome());
            ps.setString(2,  a.getCodigo());
            ps.setInt   (3,  a.getEboxes());
            ps.setString(4,  a.getAttackType());
            ps.setString(5,  a.getAttackDamage());
            ps.setString(6,  a.getRiskLevel());
            ps.setBoolean(7, a.isFacilityBenefit());
            ps.setString(8,  a.getGoodMood());
            ps.setString(9,  a.getNormalMood());
            ps.setString(10, a.getBadMood());
            ps.setString(11, a.getQliphothCounter());
            ps.setString(12, a.getDescricao());
            ps.setString(13, a.getAbility());
            ps.setString(14, a.getOriginText());
            ps.setString(15, a.getDetailsText());
            ps.setString(16, a.getStory());
            ps.setString(17, a.getFlavourText());
            ps.setString(18, a.getTrivia());
            ps.setString(19, a.getImagem());
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn);
        }
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────

    public boolean atualizar(Abnormality a) throws SQLException {
        String sql = """
            UPDATE abnormality SET
              nome=?, codigo=?, eboxes=?, attackType=?, attackDamage=?, riskLevel=?,
              facilityBenefit=?, goodMood=?, normalMood=?, badMood=?, qliphothCounter=?,
              descricao=?, ability=?, originText=?, detailsText=?, story=?, flavourText=?, trivia=?, imagem=?
            WHERE id=?
            """;
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1,  a.getNome());
            ps.setString(2,  a.getCodigo());
            ps.setInt   (3,  a.getEboxes());
            ps.setString(4,  a.getAttackType());
            ps.setString(5,  a.getAttackDamage());
            ps.setString(6,  a.getRiskLevel());
            ps.setBoolean(7, a.isFacilityBenefit());
            ps.setString(8,  a.getGoodMood());
            ps.setString(9,  a.getNormalMood());
            ps.setString(10, a.getBadMood());
            ps.setString(11, a.getQliphothCounter());
            ps.setString(12, a.getDescricao());
            ps.setString(13, a.getAbility());
            ps.setString(14, a.getOriginText());
            ps.setString(15, a.getDetailsText());
            ps.setString(16, a.getStory());
            ps.setString(17, a.getFlavourText());
            ps.setString(18, a.getTrivia());
            ps.setString(19, a.getImagem());
            ps.setInt   (20, a.getId());
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn);
        }
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────

    public boolean apagar(int id) throws SQLException {
        String sql = "DELETE FROM abnormality WHERE id=?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(conn);
        }
    }

    // ─── SELECT BY ID ────────────────────────────────────────────────────────

    public Abnormality buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM abnormality WHERE id=?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    // ─── SELECT ALL ──────────────────────────────────────────────────────────

    public List<Abnormality> listarTodos() throws SQLException {
        List<Abnormality> lista = new ArrayList<>();
        String sql = "SELECT * FROM abnormality ORDER BY nome";
        Connection conn = DBConnection.getConnection();
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) lista.add(mapRow(rs));
        } finally {
            DBConnection.close(conn);
        }
        return lista;
    }

    // ─── FILTER ──────────────────────────────────────────────────────────────

    /**
     * Filtra anormalidades por múltiplos critérios opcionais.
     * Parâmetros null/vazio são ignorados.
     */
    public List<Abnormality> filtrar(String nome, String riskLevel, String attackType,
                                      String facilityBenefit, String minEboxes, String maxEboxes)
            throws SQLException {

        StringBuilder sql = new StringBuilder("SELECT * FROM abnormality WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (nome != null && !nome.isBlank()) {
            sql.append(" AND nome LIKE ?");
            params.add("%" + nome.trim() + "%");
        }
        if (riskLevel != null && !riskLevel.isBlank()) {
            sql.append(" AND riskLevel = ?");
            params.add(riskLevel.trim());
        }
        if (attackType != null && !attackType.isBlank()) {
            sql.append(" AND attackType = ?");
            params.add(attackType.trim());
        }
        if (facilityBenefit != null && !facilityBenefit.isBlank()) {
            sql.append(" AND facilityBenefit = ?");
            params.add("1".equals(facilityBenefit) ? true : false);
        }
        if (minEboxes != null && !minEboxes.isBlank()) {
            try {
                sql.append(" AND eboxes >= ?");
                params.add(Integer.parseInt(minEboxes.trim()));
            } catch (NumberFormatException ignored) {}
        }
        if (maxEboxes != null && !maxEboxes.isBlank()) {
            try {
                sql.append(" AND eboxes <= ?");
                params.add(Integer.parseInt(maxEboxes.trim()));
            } catch (NumberFormatException ignored) {}
        }

        sql.append(" ORDER BY riskLevel, nome");

        List<Abnormality> lista = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String)  ps.setString(i+1, (String) p);
                else if (p instanceof Integer) ps.setInt(i+1, (Integer) p);
                else if (p instanceof Boolean) ps.setBoolean(i+1, (Boolean) p);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapRow(rs));
        } finally {
            DBConnection.close(conn);
        }
        return lista;
    }

    // ─── COUNT ───────────────────────────────────────────────────────────────

    public int contarTotal() throws SQLException {
        Connection conn = DBConnection.getConnection();
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM abnormality")) {
            if (rs.next()) return rs.getInt(1);
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }

    // ─── ROW MAPPER ──────────────────────────────────────────────────────────

    private Abnormality mapRow(ResultSet rs) throws SQLException {
        Abnormality a = new Abnormality();
        a.setId(rs.getInt("id"));
        a.setNome(rs.getString("nome"));
        a.setCodigo(rs.getString("codigo"));
        a.setEboxes(rs.getInt("eboxes"));
        a.setAttackType(rs.getString("attackType"));
        a.setAttackDamage(rs.getString("attackDamage"));
        a.setRiskLevel(rs.getString("riskLevel"));
        a.setFacilityBenefit(rs.getBoolean("facilityBenefit"));
        a.setGoodMood(rs.getString("goodMood"));
        a.setNormalMood(rs.getString("normalMood"));
        a.setBadMood(rs.getString("badMood"));
        a.setQliphothCounter(rs.getString("qliphothCounter"));
        a.setDescricao(rs.getString("descricao"));
        a.setAbility(rs.getString("ability"));
        a.setOriginText(rs.getString("originText"));
        a.setDetailsText(rs.getString("detailsText"));
        a.setStory(rs.getString("story"));
        a.setFlavourText(rs.getString("flavourText"));
        a.setTrivia(rs.getString("trivia"));
        a.setImagem(rs.getString("imagem"));
        return a;
    }
}

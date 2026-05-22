package dao;

import model.Observation;
import java.sql.*;
import java.util.*;

public class ObservationDAO {

    public List<Observation> buscarPorAbnormality(int abnormalityId) throws SQLException {
        List<Observation> lista = new ArrayList<>();
        String sql = "SELECT * FROM observation WHERE abnormality_id = ? ORDER BY levelNumber";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, abnormalityId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Observation o = new Observation();
                o.setId(rs.getInt("id"));
                o.setAbnormalityId(rs.getInt("abnormality_id"));
                o.setLevelNumber(rs.getInt("levelNumber"));
                o.setBonus(rs.getString("bonus"));
                o.setUnlockText(rs.getString("unlockText"));
                lista.add(o);
            }
        } finally {
            DBConnection.close(conn);
        }
        return lista;
    }
}

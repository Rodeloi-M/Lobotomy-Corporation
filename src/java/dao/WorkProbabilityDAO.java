package dao;

import model.WorkProbability;
import java.sql.*;
import java.util.*;

public class WorkProbabilityDAO {

    public List<WorkProbability> buscarPorAbnormality(int abnormalityId) throws SQLException {
        List<WorkProbability> lista = new ArrayList<>();
        String sql = "SELECT * FROM work_probability WHERE abnormality_id = ? ORDER BY id";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, abnormalityId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                WorkProbability wp = new WorkProbability();
                wp.setId(rs.getInt("id"));
                wp.setAbnormalityId(rs.getInt("abnormality_id"));
                wp.setWorkType(rs.getString("workType"));
                wp.setLevel1(rs.getString("level1"));
                wp.setLevel2(rs.getString("level2"));
                wp.setLevel3(rs.getString("level3"));
                wp.setLevel4(rs.getString("level4"));
                wp.setLevel5(rs.getString("level5"));
                lista.add(wp);
            }
        } finally {
            DBConnection.close(conn);
        }
        return lista;
    }
}

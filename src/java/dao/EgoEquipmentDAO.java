package dao;

import model.EgoEquipment;
import java.sql.*;
import java.util.*;

public class EgoEquipmentDAO {

    public List<EgoEquipment> buscarPorAbnormality(int abnormalityId) throws SQLException {
        List<EgoEquipment> lista = new ArrayList<>();
        String sql = "SELECT * FROM ego_equipment WHERE abnormality_id = ? ORDER BY id";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, abnormalityId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EgoEquipment e = new EgoEquipment();
                e.setId(rs.getInt("id"));
                e.setAbnormalityId(rs.getInt("abnormality_id"));
                e.setWeaponName(rs.getString("weaponName"));
                e.setGrade(rs.getString("grade"));
                e.setCost(rs.getInt("cost"));
                e.setMaxAmount(rs.getInt("maxAmount"));
                e.setDamage(rs.getString("damage"));
                e.setAttackSpeed(rs.getString("attackSpeed"));
                e.setRangeType(rs.getString("rangeType"));
                e.setObservationLevel(rs.getInt("observationLevel"));
                e.setRequirements(rs.getString("requirements"));
                e.setSpecialInfo(rs.getString("specialInfo"));
                lista.add(e);
            }
        } finally {
            DBConnection.close(conn);
        }
        return lista;
    }
}

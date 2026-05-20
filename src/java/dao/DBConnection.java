package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe utilitária para gestão da ligação à base de dados MySQL.
 * Lobotomy Corporation Wiki — Projeto Académico
 */
public class DBConnection {

    private static final String URL      = "jdbc:mysql://localhost:3306/lobotomy_corp?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String USER     = "root";
    private static final String PASSWORD = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("Driver MySQL não encontrado: " + e.getMessage());
        }
    }

    /**
     * Obtém uma conexão com a base de dados.
     * @return Connection activa
     * @throws SQLException se a ligação falhar
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * Fecha a conexão em segurança.
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}

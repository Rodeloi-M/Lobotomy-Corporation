package DataBase;

import java.sql.*;

public class DataBaseConnection {

    public static Connection getConnection() {

        Connection con = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/lobotomy_corp",
                "root",
                "admin1234"
            );

        } catch (Exception e) {
            System.out.println(e);
        }

        return con;
    }
}

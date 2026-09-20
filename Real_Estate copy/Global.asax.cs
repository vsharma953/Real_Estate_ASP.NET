using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Real_Estate
{
    public class Global : System.Web.HttpApplication
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;


        // Runs once when the site starts. It only adds what is missing
        // (Agents table, SiteAdmins table, Properties.AgentID column),
        // so the site works without running any SQL by hand.
        protected void Application_Start(object sender, EventArgs e)
        {
            try
            {
                createTables();
            }
            catch (Exception)
            {
                // never stop the public website from starting because of this
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        void createTables()
        {
            getcon();

            cmd = new SqlCommand(
                "IF OBJECT_ID('dbo.Agents','U') IS NULL " +
                "BEGIN " +
                "CREATE TABLE dbo.Agents (" +
                "AgentID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, " +
                "FullName NVARCHAR(100) NOT NULL, " +
                "Email NVARCHAR(150) NOT NULL, " +
                "Phone NVARCHAR(20) NOT NULL DEFAULT '', " +
                "[Password] NVARCHAR(100) NOT NULL, " +
                "Status NVARCHAR(20) NOT NULL DEFAULT 'Active'); " +
                "INSERT INTO dbo.Agents (FullName, Email, Phone, [Password], Status) " +
                "VALUES ('Julian Vance', 'admin@realestate.luxury', '', 'admin123', 'Active'); " +
                "END", con);
            cmd.ExecuteNonQuery();

            cmd = new SqlCommand(
                "IF OBJECT_ID('dbo.SiteAdmins','U') IS NULL " +
                "BEGIN " +
                "CREATE TABLE dbo.SiteAdmins (" +
                "AdminID INT IDENTITY(1,1) NOT NULL PRIMARY KEY, " +
                "Email NVARCHAR(150) NOT NULL, " +
                "[Password] NVARCHAR(100) NOT NULL); " +
                "INSERT INTO dbo.SiteAdmins (Email, [Password]) " +
                "VALUES ('siteadmin@realestate.luxury', 'siteadmin123'); " +
                "END", con);
            cmd.ExecuteNonQuery();

            da = new SqlDataAdapter("SELECT COL_LENGTH('dbo.Properties','AgentID')", con);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables[0].Rows[0][0] == DBNull.Value)
            {
                cmd = new SqlCommand("ALTER TABLE dbo.Properties ADD AgentID INT NULL", con);
                cmd.ExecuteNonQuery();

                // every property listed so far was added from the one existing Agent Desk login
                cmd = new SqlCommand("UPDATE dbo.Properties SET AgentID = (SELECT MIN(AgentID) FROM dbo.Agents)", con);
                cmd.ExecuteNonQuery();
            }

            con.Close();
        }
    }
}

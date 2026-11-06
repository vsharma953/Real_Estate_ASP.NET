using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using CrystalDecisions.Web.Design;

namespace Real_Estate.SiteAdmin
{
    public partial class CrystalReport : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        private CrystalDecisions.CrystalReports.Engine.ReportDocument cr = new ReportDocument();
        static string Crypath = "";

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        void makeXMLfile(string query, string tableName, string fileName)
        {
            getcon();

            da = new SqlDataAdapter(query, con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            ds.Tables[0].TableName = tableName;
            ds.WriteXmlSchema(Server.MapPath("~/Reports/" + fileName));
        }

        protected void btnGenerateXML_Click(object sender, EventArgs e)
        {
            makeXMLfile(
                "SELECT d.DealID, a.FullName AS AgentName, d.ClientName, d.PropertyTitle, d.PropertyLocation, " +
                "d.ListedPrice, d.FinalPrice, d.ClosingDate, d.Status " +
                "FROM Deals d INNER JOIN Agents a ON a.AgentID = d.AgentID " +
                "WHERE d.DealType = 'sale' AND d.Status IN ('Approved','Paid') ORDER BY a.FullName",
                "SalesReport", "Sales.xml");

            makeXMLfile(
                "SELECT d.DealID, a.FullName AS AgentName, d.ClientName, d.PropertyTitle, d.PropertyLocation, " +
                "d.MonthlyRent, d.SecurityDeposit, d.LeaseStart, d.LeaseEnd " +
                "FROM Deals d INNER JOIN Agents a ON a.AgentID = d.AgentID " +
                "WHERE d.DealType = 'rent' ORDER BY a.FullName",
                "RentalReport", "Rental.xml");

            makeXMLfile(
                "SELECT a.FullName AS AgentName, COUNT(d.DealID) AS DealCount, " +
                "ISNULL(SUM(CASE WHEN d.DealType = 'sale' THEN d.FinalPrice END), 0) AS SalesValue, " +
                "ISNULL(SUM(d.CommissionAmount), 0) AS TotalCommission " +
                "FROM Agents a LEFT JOIN Deals d ON d.AgentID = a.AgentID AND d.Status IN ('Approved','Paid') " +
                "GROUP BY a.FullName",
                "AgentPerformance", "AgentPerformance.xml");

            makeXMLfile(
                "SELECT d.DealID, a.FullName AS AgentName, d.PropertyTitle, d.FinalPrice, " +
                "d.CommissionPercent, d.CommissionAmount, d.Status, d.CommissionPaidOn " +
                "FROM Deals d INNER JOIN Agents a ON a.AgentID = d.AgentID " +
                "WHERE d.DealType = 'sale' AND d.Status IN ('Approved','Paid') ORDER BY a.FullName",
                "CommissionReport", "Commission.xml");

            makeXMLfile(
                "SELECT i.InquiryID, i.FullName AS ClientName, i.Phone, i.Property, i.InquiryDate, i.Status, " +
                "ISNULL(a.FullName, 'Unassigned') AS AgentName " +
                "FROM Inquiries i LEFT JOIN Properties p ON p.PropertyID = i.PropertyID " +
                "LEFT JOIN Agents a ON a.AgentID = ISNULL(i.AssignedAgentID, p.AgentID) " +
                "ORDER BY i.Status",
                "InquiryReport", "Inquiry.xml");
        }
    }
}
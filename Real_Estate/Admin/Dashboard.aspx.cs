using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace Real_Estate.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        // how many inquiries the dashboard preview shows (the full list is on the Inquiries page)
        int recentCount = 10;


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                gridfield();
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        // Only inquiries owned by the logged-in agent: assigned to them by the SiteAdmin,
        // or (when not assigned) for one of their properties
        void gridfield()
        {
            int agentId;

            if (!int.TryParse(Convert.ToString(Session["AgentID"]), out agentId))
            {
                gvRecentInquiries.DataSource = null;
                gvRecentInquiries.DataBind();
                return;
            }

            getcon();

            da = new SqlDataAdapter(
    "SELECT TOP " + recentCount + " i.InquiryID, i.FullName, i.Email, i.Phone, i.Property, i.Message, i.InquiryDate, i.Status " +
    "FROM Inquiries i " +
    "LEFT JOIN Properties p ON p.PropertyID = i.PropertyID " +
    "WHERE ISNULL(i.AssignedAgentID, p.AgentID) = '" + agentId + "' " +
    "ORDER BY i.InquiryID DESC", con);

            ds = new DataSet();
            da.Fill(ds);

            gvRecentInquiries.DataSource = ds;
            gvRecentInquiries.DataBind();

            con.Close();
        }


        // digits and + only, so the number works in a tel: link
        protected string TelHref(object phone)
        {
            return "tel:" + Regex.Replace(Convert.ToString(phone), @"[^\d+]", "");
        }
    }
}

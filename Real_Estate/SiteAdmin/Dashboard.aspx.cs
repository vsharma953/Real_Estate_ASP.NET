using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace Real_Estate.SiteAdmin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadStats();
                gridfield();
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        void loadStats()
        {
            getcon();

            da = new SqlDataAdapter("SELECT * FROM Agents", con);
            ds = new DataSet();
            da.Fill(ds);
            litTotalAgents.Text = ds.Tables[0].Rows.Count.ToString();


            da = new SqlDataAdapter("SELECT * FROM Agents WHERE Status = 'Active'", con);
            ds = new DataSet();
            da.Fill(ds);
            litActiveAgents.Text = ds.Tables[0].Rows.Count.ToString();


            da = new SqlDataAdapter("SELECT * FROM Properties", con);
            ds = new DataSet();
            da.Fill(ds);
            litTotalProperties.Text = ds.Tables[0].Rows.Count.ToString();


            da = new SqlDataAdapter("SELECT * FROM Inquiries", con);
            ds = new DataSet();
            da.Fill(ds);
            litTotalInquiries.Text = ds.Tables[0].Rows.Count.ToString();

            da = new SqlDataAdapter("SELECT * FROM Properties WHERE Status = 'Sold'", con);
            ds = new DataSet();
            da.Fill(ds);

            decimal total = 0;

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                string price = Regex.Replace(row["Price"].ToString(), @"[.,]\d{1,2}$", "");
                price = Regex.Replace(price, @"\D", "");

                if (price != "")
                {
                    total += decimal.Parse(price);
                }
            }

            litTotalSell.Text = "$" + total.ToString("N0");

            con.Close();
        }


        void gridfield()
        {
            getcon();

            da = new SqlDataAdapter("SELECT Agents.AgentID, Agents.FullName, Agents.Email, Agents.Status, (SELECT COUNT(*) FROM Properties WHERE Properties.AgentID = Agents.AgentID) AS Listings FROM Agents ORDER BY Agents.AgentID DESC", con);

            ds = new DataSet();
            da.Fill(ds);

            gvRecentAgents.DataSource = ds;
            gvRecentAgents.DataBind();

            con.Close();
        }
    }
}

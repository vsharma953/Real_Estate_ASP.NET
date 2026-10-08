using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Real_Estate.SiteAdmin
{
    public partial class AgentWork : System.Web.UI.Page
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
                loadAgentFilter();
                gridfield();
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        void loadAgentFilter()
        {
            getcon();

            da = new SqlDataAdapter("SELECT * FROM Agents ORDER BY FullName", con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            ddlAgentFilter.Items.Clear();
            ddlAgentFilter.Items.Add(new ListItem("All Agents", "0"));

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                ddlAgentFilter.Items.Add(new ListItem(row["FullName"].ToString(), row["AgentID"].ToString()));
            }

            ddlAgentFilter.Items.Add(new ListItem("Unassigned", "-1"));
        }


        void gridfield()
        {
            getcon();

            string query = "SELECT Properties.PropertyID, Properties.Title, Properties.AgentID, ISNULL(Agents.FullName, 'Unassigned') AS AgentName, Properties.PropertyType, Properties.Price, Properties.Location, Properties.Status FROM Properties LEFT JOIN Agents ON Properties.AgentID = Agents.AgentID";

            if (ddlAgentFilter.SelectedValue == "-1")
            {
                query += " WHERE Properties.AgentID IS NULL";
            }
            else if (ddlAgentFilter.SelectedValue != "0")
            {
                query += " WHERE Properties.AgentID = '" + ddlAgentFilter.SelectedValue + "'";
            }

            query += " ORDER BY Properties.PropertyID DESC";

            da = new SqlDataAdapter(query, con);

            ds = new DataSet();
            da.Fill(ds);

            gvAgentWork.DataSource = ds;
            gvAgentWork.DataBind();

            con.Close();
        }

        protected void ddlAgentFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            gridfield();
        }

        protected void gvAgentWork_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteRow")
            {
                getcon();

                cmd = new SqlCommand("DELETE FROM Properties WHERE PropertyID='" + e.CommandArgument.ToString() + "'", con);
                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Listing removed successfully.";
                lblMessage.Visible = true;

                gridfield();
            }
        }
    }
}
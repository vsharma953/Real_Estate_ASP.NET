using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
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

        DataTable agents;   // Agents, loaded once per request (filter + "Move To" dropdowns)


        protected void Page_Load(object sender, EventArgs e)
        {
            loadAgents();

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


        // makes text safe inside '...'
        string q(string value)
        {
            return value.Replace("'", "''");
        }


        // "John Smith" or "John Smith (Inactive)" when the agent is not Active
        string agentLabel(DataRow r)
        {
            string label = r["FullName"].ToString();
            string status = r["Status"].ToString().Trim();

            if (status != "Active" && status != "")
            {
                label += " (" + status + ")";
            }

            return label;
        }


        void loadAgents()
        {
            getcon();

            da = new SqlDataAdapter("SELECT AgentID, FullName, Status FROM Agents ORDER BY FullName", con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            agents = ds.Tables[0];
        }


        void loadAgentFilter()
        {
            ddlAgentFilter.Items.Clear();
            ddlAgentFilter.Items.Add(new ListItem("All Agents", "0"));

            foreach (DataRow row in agents.Rows)
            {
                ddlAgentFilter.Items.Add(new ListItem(agentLabel(row), row["AgentID"].ToString()));
            }

            ddlAgentFilter.Items.Add(new ListItem("Unassigned", "-1"));
        }


        // ---------- Sale / Rent tabs ----------

        // part of the WHERE clause for the agent filter ("" = all agents)
        string agentCondition()
        {
            int id;
            int.TryParse(ddlAgentFilter.SelectedValue, out id);

            if (id == -1) return "Properties.AgentID IS NULL";
            if (id > 0) return "Properties.AgentID = '" + id + "'";

            return "";
        }


        // one tab per listing type found in Properties (no names in code);
        // the count on each tab follows the agent filter
        DataTable buildTabs()
        {
            getcon();

            da = new SqlDataAdapter("SELECT DISTINCT LOWER(LTRIM(RTRIM(ListingType))) AS ListingKey FROM Properties WHERE ListingType IS NOT NULL ORDER BY 1 DESC", con);
            DataSet types = new DataSet();
            da.Fill(types);

            string cond = agentCondition();

            da = new SqlDataAdapter("SELECT LOWER(LTRIM(RTRIM(ListingType))) AS ListingKey, COUNT(*) AS Total FROM Properties" +
                (cond == "" ? "" : " WHERE " + cond) +
                " GROUP BY LOWER(LTRIM(RTRIM(ListingType)))", con);
            DataSet counts = new DataSet();
            da.Fill(counts);

            con.Close();

            DataTable tabs = new DataTable();
            tabs.Columns.Add("Value");
            tabs.Columns.Add("Text");
            tabs.Columns.Add("Total");

            foreach (DataRow t in types.Tables[0].Rows)
            {
                string key = t["ListingKey"].ToString();

                if (key == "") continue;

                int total = 0;

                foreach (DataRow c in counts.Tables[0].Rows)
                {
                    if (c["ListingKey"].ToString() == key)
                    {
                        total = Convert.ToInt32(c["Total"]);
                    }
                }

                tabs.Rows.Add(key, "For " + char.ToUpper(key[0]) + key.Substring(1), total);
            }

            return tabs;
        }


        protected bool IsActiveTab(object value)
        {
            return value.ToString() == Convert.ToString(ViewState["Listing"]);
        }


        protected void rptTabs_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Tab")
            {
                ViewState["Listing"] = e.CommandArgument.ToString();

                lblMessage.Text = "";
                lblMessage.Visible = false;

                gridfield();
            }
        }


        void gridfield()
        {
            DataTable tabs = buildTabs();

            // keep the chosen tab, or fall back to the first one
            string listing = Convert.ToString(ViewState["Listing"]);

            if (tabs.Select("Value = '" + q(listing) + "'").Length == 0)
            {
                listing = tabs.Rows.Count > 0 ? tabs.Rows[0]["Value"].ToString() : "";
            }

            ViewState["Listing"] = listing;

            rptTabs.DataSource = tabs;
            rptTabs.DataBind();

            string query = "SELECT Properties.PropertyID, Properties.Title, Properties.AgentID, ISNULL(Agents.FullName, 'Unassigned') AS AgentName, Properties.PropertyType, Properties.ListingType, Properties.Price, Properties.Location, Properties.Status, " +
                "(SELECT COUNT(*) FROM Inquiries WHERE Inquiries.PropertyID = Properties.PropertyID) AS InquiryCount " +
                "FROM Properties LEFT JOIN Agents ON Properties.AgentID = Agents.AgentID WHERE 1 = 1";

            if (listing != "")
            {
                query += " AND LOWER(LTRIM(RTRIM(Properties.ListingType))) = '" + q(listing) + "'";
            }

            string cond = agentCondition();

            if (cond != "")
            {
                query += " AND " + cond;
            }

            query += " ORDER BY Properties.PropertyID DESC";

            getcon();

            da = new SqlDataAdapter(query, con);

            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            gvAgentWork.DataSource = ds;
            gvAgentWork.DataBind();
        }


        protected void ddlAgentFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblMessage.Visible = false;
            gridfield();
        }


        // fills each row's "Move To" dropdown with the property's current agent selected
        protected void gvAgentWork_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            DropDownList ddl = (DropDownList)e.Row.FindControl("ddlMoveTo");

            ddl.Items.Add(new ListItem("Unassigned", "0"));

            foreach (DataRow r in agents.Rows)
            {
                ddl.Items.Add(new ListItem(agentLabel(r), r["AgentID"].ToString()));
            }

            object current = DataBinder.Eval(e.Row.DataItem, "AgentID");

            if (current != null && current != DBNull.Value)
            {
                ListItem item = ddl.Items.FindByValue(current.ToString());

                if (item != null)
                {
                    ddl.ClearSelection();
                    item.Selected = true;
                }
            }
        }


        protected void gvAgentWork_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int propertyId;

            if (!int.TryParse(Convert.ToString(e.CommandArgument), out propertyId)) return;

            if (e.CommandName == "DeleteRow")
            {
                getcon();

                cmd = new SqlCommand("DELETE FROM Properties WHERE PropertyID='" + propertyId + "'", con);
                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Listing removed successfully.";
                lblMessage.Visible = true;

                gridfield();
            }

            else if (e.CommandName == "MoveRow")
            {
                GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
                DropDownList ddl = (DropDownList)row.FindControl("ddlMoveTo");

                int agentId;

                if (!int.TryParse(ddl.SelectedValue, out agentId)) return;

                // 0 = no agent
                string value = agentId == 0 ? "NULL" : "'" + agentId + "'";

                getcon();

                cmd = new SqlCommand("UPDATE Properties SET AgentID = " + value + " WHERE PropertyID='" + propertyId + "'", con);
                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = agentId == 0
                    ? "Listing is now unassigned."
                    : "Listing moved to the selected agent. Its inquiries follow the listing unless you assigned them separately.";
                lblMessage.Visible = true;

                gridfield();
            }
        }
    }
}

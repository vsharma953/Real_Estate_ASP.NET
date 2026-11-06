using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Real_Estate.SiteAdmin
{
    public partial class Inquiries : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        DataTable agents;   // Agents, loaded once per request (filter + "Assign To" dropdowns)


        protected void Page_Load(object sender, EventArgs e)
        {
            loadAgents();

            if (!IsPostBack)
            {
                loadFilters();
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


        string listingText(string key)
        {
            return key == "" ? "" : "For " + char.ToUpper(key[0]) + key.Substring(1);
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


        void loadFilters()
        {
            // agents
            ddlAgentFilter.Items.Clear();
            ddlAgentFilter.Items.Add(new ListItem("All agents", "0"));

            foreach (DataRow r in agents.Rows)
            {
                ddlAgentFilter.Items.Add(new ListItem(agentLabel(r), r["AgentID"].ToString()));
            }

            ddlAgentFilter.Items.Add(new ListItem("Unassigned", "-1"));

            getcon();

            // listing types come from the properties themselves
            da = new SqlDataAdapter("SELECT DISTINCT LOWER(LTRIM(RTRIM(ListingType))) AS ListingKey FROM Properties WHERE ListingType IS NOT NULL ORDER BY 1 DESC", con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            ddlListingFilter.Items.Clear();
            ddlListingFilter.Items.Add(new ListItem("All types", ""));

            foreach (DataRow r in ds.Tables[0].Rows)
            {
                string key = r["ListingKey"].ToString();

                if (key != "")
                {
                    ddlListingFilter.Items.Add(new ListItem(listingText(key), key));
                }
            }
        }


        void gridfield()
        {
            string query =
                "SELECT i.InquiryID, i.FullName, i.Email, i.Phone, i.Property, i.Message, i.InquiryDate, i.AgentNote, i.AssignedAgentID, " +
                "p.ListingType, p.Location, i.Status AS StatusName, " +
                "ISNULL(i.AssignedAgentID, p.AgentID) AS OwnerID, " +
                "ISNULL(a.FullName, 'Unassigned') AS AgentName " +
                "FROM Inquiries i " +
                "LEFT JOIN Properties p ON p.PropertyID = i.PropertyID " +
                "LEFT JOIN Agents a ON a.AgentID = ISNULL(i.AssignedAgentID, p.AgentID) " +
                "WHERE 1 = 1";

            int agentFilter;
            int.TryParse(ddlAgentFilter.SelectedValue, out agentFilter);

            if (agentFilter == -1)
            {
                query += " AND ISNULL(i.AssignedAgentID, p.AgentID) IS NULL";
            }
            else if (agentFilter > 0)
            {
                query += " AND ISNULL(i.AssignedAgentID, p.AgentID) = '" + agentFilter + "'";
            }

            // the status text comes from the dropdown's own items
            if (ddlStatusFilter.SelectedValue != "")
            {
                query += " AND i.Status = '" + q(ddlStatusFilter.SelectedValue) + "'";
            }

            // the value always comes from the dropdown's own items
            if (ddlListingFilter.SelectedValue != "")
            {
                query += " AND LOWER(LTRIM(RTRIM(p.ListingType))) = '" + q(ddlListingFilter.SelectedValue) + "'";
            }

            DateTime from, to;

            if (DateTime.TryParse(txtFrom.Text, out from))
            {
                query += " AND i.InquiryDate >= '" + from.ToString("yyyyMMdd") + "'";
            }

            if (DateTime.TryParse(txtTo.Text, out to))
            {
                query += " AND i.InquiryDate < '" + to.AddDays(1).ToString("yyyyMMdd") + "'";
            }

            query += " ORDER BY i.InquiryID DESC";

            getcon();

            da = new SqlDataAdapter(query, con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            int unassigned = 0;

            foreach (DataRow r in ds.Tables[0].Rows)
            {
                if (r["OwnerID"] == DBNull.Value) unassigned++;
            }

            lblSummary.Text = ds.Tables[0].Rows.Count + " inquiries shown, " + unassigned + " unassigned.";

            gvInquiries.DataSource = ds;
            gvInquiries.DataBind();
        }


        protected void filter_Changed(object sender, EventArgs e)
        {
            lblMessage.Visible = false;
            gridfield();
        }


        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlAgentFilter.SelectedIndex = 0;
            ddlStatusFilter.SelectedIndex = 0;
            ddlListingFilter.SelectedIndex = 0;
            txtFrom.Text = "";
            txtTo.Text = "";

            lblMessage.Visible = false;
            gridfield();
        }


        // fills each row's "Assign To" dropdown
        protected void gvInquiries_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            DropDownList ddl = (DropDownList)e.Row.FindControl("ddlAssign");

            ddl.Items.Add(new ListItem("Property's agent (default)", "0"));

            foreach (DataRow r in agents.Rows)
            {
                ddl.Items.Add(new ListItem(agentLabel(r), r["AgentID"].ToString()));
            }

            object assigned = DataBinder.Eval(e.Row.DataItem, "AssignedAgentID");

            if (assigned != null && assigned != DBNull.Value)
            {
                ListItem item = ddl.Items.FindByValue(assigned.ToString());

                if (item != null)
                {
                    ddl.ClearSelection();
                    item.Selected = true;
                }
            }
        }


        protected void gvInquiries_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "AssignRow") return;

            int inquiryId, agentId;

            if (!int.TryParse(Convert.ToString(e.CommandArgument), out inquiryId)) return;

            GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
            DropDownList ddl = (DropDownList)row.FindControl("ddlAssign");

            if (!int.TryParse(ddl.SelectedValue, out agentId)) return;

            // 0 = back to the property's own agent
            string value = agentId == 0 ? "NULL" : "'" + agentId + "'";

            getcon();

            cmd = new SqlCommand("UPDATE Inquiries SET AssignedAgentID = " + value + " WHERE InquiryID = '" + inquiryId + "'", con);
            cmd.ExecuteNonQuery();

            con.Close();

            lblMessage.Text = agentId == 0
                ? "Inquiry returned to the property's agent."
                : "Inquiry assigned successfully.";
            lblMessage.Visible = true;

            gridfield();
        }

        protected string TelHref(object phone)
        {
            return "tel:" + Regex.Replace(Convert.ToString(phone), @"[^\d+]", "");
        }

        protected string PropertyMeta(object listing, object location)
        {
            string l = Convert.ToString(listing).Trim().ToLower();
            string text = listingText(l);
            string loc = Convert.ToString(location).Trim();

            if (loc != "") text += (text == "" ? "" : " - ") + loc;

            return Server.HtmlEncode(text);
        }


        // the agent's note, shown under the message (already HTML-encoded)
        protected string NoteHtml(object note)
        {
            string n = Convert.ToString(note).Trim();

            return n == "" ? "" : "<div class=\"muted\">Agent note: " + Server.HtmlEncode(n) + "</div>";
        }
    }
}

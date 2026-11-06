using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Real_Estate.SiteAdmin
{
    public partial class Deals : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        string cur = "$";


        protected void Page_Load(object sender, EventArgs e)
        {
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


        string q(string value)
        {
            return value.Replace("'", "''");
        }


        string typeLabel(string key)
        {
            return key == "" ? "" : "For " + char.ToUpper(key[0]) + key.Substring(1);
        }


        void loadFilters()
        {
            getcon();

            // agents
            da = new SqlDataAdapter("SELECT AgentID, FullName FROM Agents ORDER BY FullName", con);
            ds = new DataSet();
            da.Fill(ds);

            ddlAgentFilter.Items.Clear();
            ddlAgentFilter.Items.Add(new ListItem("All agents", "0"));

            foreach (DataRow r in ds.Tables[0].Rows)
            {
                ddlAgentFilter.Items.Add(new ListItem(r["FullName"].ToString(), r["AgentID"].ToString()));
            }

            // deal types found in the deals themselves
            da = new SqlDataAdapter("SELECT DISTINCT DealType FROM Deals ORDER BY DealType DESC", con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            ddlTypeFilter.Items.Clear();
            ddlTypeFilter.Items.Add(new ListItem("All types", ""));

            foreach (DataRow r in ds.Tables[0].Rows)
            {
                string key = r["DealType"].ToString();
                ddlTypeFilter.Items.Add(new ListItem(typeLabel(key), key));
            }
        }


        // the deals matching the filters (used by the grid and the cards)
        DataTable fetch()
        {
            string query =
                "SELECT d.DealID, d.DealType, d.CreatedOn, d.AgentID, ISNULL(a.FullName, 'Unassigned') AS AgentName, " +
                "d.PropertyTitle, d.PropertyLocation, d.PropertyType, d.ListedPrice, d.ClientName, d.ClientEmail, d.ClientPhone, " +
                "d.FinalPrice, d.ClosingDate, d.MonthlyRent, d.SecurityDeposit, d.LeaseStart, d.LeaseEnd, " +
                "d.CommissionPercent, d.CommissionAmount, d.Status, " +
                "ISNULL((SELECT SUM(Amount) FROM DealPayments WHERE DealPayments.DealID = d.DealID), 0) AS Paid " +
                "FROM Deals d " +
                "LEFT JOIN Agents a ON a.AgentID = d.AgentID " +
                "WHERE 1 = 1";

            int agentFilter;
            int.TryParse(ddlAgentFilter.SelectedValue, out agentFilter);

            if (agentFilter > 0) query += " AND d.AgentID = '" + agentFilter + "'";

            // the status text comes from the dropdown's own items
            if (ddlStatusFilter.SelectedValue != "") query += " AND d.Status = '" + q(ddlStatusFilter.SelectedValue) + "'";

            // the value always comes from the dropdown's own items
            if (ddlTypeFilter.SelectedValue != "") query += " AND d.DealType = '" + q(ddlTypeFilter.SelectedValue) + "'";

            DateTime from, to;

            if (DateTime.TryParse(txtFrom.Text, out from)) query += " AND d.CreatedOn >= '" + from.ToString("yyyyMMdd") + "'";
            if (DateTime.TryParse(txtTo.Text, out to)) query += " AND d.CreatedOn < '" + to.AddDays(1).ToString("yyyyMMdd") + "'";

            query += " ORDER BY d.DealID DESC";

            getcon();

            da = new SqlDataAdapter(query, con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            return ds.Tables[0];
        }


        void gridfield()
        {
            DataTable dt = fetch();

            int total = 0, pending = 0, rentals = 0;
            decimal salesValue = 0, due = 0, paid = 0;

            foreach (DataRow r in dt.Rows)
            {
                string role = r["Status"].ToString();

                if (role != "Rejected") total++;
                if (role == "Pending") pending++;
                if (role != "Rejected" && r["DealType"].ToString() == "rent") rentals++;

                if (role == "Approved" || role == "Paid")
                {
                    if (r["FinalPrice"] != DBNull.Value) salesValue += Convert.ToDecimal(r["FinalPrice"]);
                }

                if (r["CommissionAmount"] != DBNull.Value)
                {
                    if (role == "Approved") due += Convert.ToDecimal(r["CommissionAmount"]);
                    if (role == "Paid") paid += Convert.ToDecimal(r["CommissionAmount"]);
                }
            }

            string c = Server.HtmlEncode(cur);

            litTotal.Text = total.ToString();
            litPending.Text = pending.ToString();
            litSalesValue.Text = c + salesValue.ToString("N2");
            litDue.Text = c + due.ToString("N2");
            litPaid.Text = c + paid.ToString("N2");
            litRentals.Text = rentals.ToString();

            gvDeals.DataSource = dt;
            gvDeals.DataBind();
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
            ddlTypeFilter.SelectedIndex = 0;
            txtFrom.Text = "";
            txtTo.Text = "";

            lblMessage.Visible = false;
            gridfield();
        }


        // ---------- helpers used by the grid (all output is HTML-encoded) ----------
        string money(object v)
        {
            return v == null || v == DBNull.Value ? "-" : Server.HtmlEncode(cur) + Convert.ToDecimal(v).ToString("N2");
        }


        string date(object v)
        {
            return v == null || v == DBNull.Value ? "-" : Convert.ToDateTime(v).ToString("dd/MM/yyyy");
        }


        protected string TypeText(object type)
        {
            return Server.HtmlEncode(typeLabel(Convert.ToString(type)));
        }


        protected string TermsHtml(object item)
        {
            DataRowView r = (DataRowView)item;

            if (r["DealType"].ToString() == "rent")
            {
                return "Rent: <strong>" + money(r["MonthlyRent"]) + "</strong> / month<br />" +
                    "<span class=\"muted\">Deposit " + money(r["SecurityDeposit"]) + "<br />" +
                    "Lease " + date(r["LeaseStart"]) + " to " + date(r["LeaseEnd"]) + "</span>";
            }

            string html = "Listed: " + money(r["ListedPrice"]) + "<br />Final: <strong>" + money(r["FinalPrice"]) + "</strong>";

            if (r["ListedPrice"] != DBNull.Value && r["FinalPrice"] != DBNull.Value)
            {
                decimal discount = Convert.ToDecimal(r["ListedPrice"]) - Convert.ToDecimal(r["FinalPrice"]);

                if (discount > 0) html += "<br /><span class=\"muted\">Discount " + money(discount) + "</span>";
            }

            return html + "<br /><span class=\"muted\">Closing " + date(r["ClosingDate"]) + "</span>";
        }


        protected string MoneyHtml(object item)
        {
            DataRowView r = (DataRowView)item;
            decimal paid = Convert.ToDecimal(r["Paid"]);

            string html = "Paid: <strong>" + money(paid) + "</strong>";

            if (r["DealType"].ToString() == "sale" && r["FinalPrice"] != DBNull.Value)
            {
                html += "<br />Balance: " + money(Convert.ToDecimal(r["FinalPrice"]) - paid);
            }

            return html;
        }


        protected string CommissionHtml(object item)
        {
            DataRowView r = (DataRowView)item;

            if (r["DealType"].ToString() != "sale") return "<span class=\"muted\">None for rentals</span>";

            if (r["CommissionAmount"] == DBNull.Value) return "<span class=\"muted\">Not approved yet</span>";

            return "<strong>" + money(r["CommissionAmount"]) + "</strong><br /><span class=\"muted\">" +
                Convert.ToDecimal(r["CommissionPercent"]).ToString("0.##") + "%</span>";
        }
    }
}

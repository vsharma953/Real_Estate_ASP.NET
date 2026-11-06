using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Real_Estate.Admin
{
    public partial class MyDeals : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        string cur = "$";


        int agentId
        {
            get
            {
                int id;
                return int.TryParse(Convert.ToString(Session["AgentID"]), out id) ? id : 0;
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                gridfield();

                int saved;

                if (int.TryParse(Request.QueryString["saved"], out saved))
                {
                    showMessage("Deal #" + saved + " was saved. A sale now waits for the site administrator's approval; a rental is recorded straight away.", true);
                }
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


        void showMessage(string text, bool success)
        {
            lblMessage.Text = Server.HtmlEncode(text);
            lblMessage.CssClass = "notice" + (success ? "" : " notice-error");
            lblMessage.Visible = true;
        }


        // all of this agent's deals; the cards use every row, the grid uses the filter
        void gridfield()
        {
            getcon();

            da = new SqlDataAdapter(
                "SELECT d.DealID, d.DealType, d.CreatedOn, d.PropertyTitle, d.PropertyLocation, d.ClientName, d.ClientEmail, d.ClientPhone, " +
                "d.ListedPrice, d.FinalPrice, d.MonthlyRent, d.SecurityDeposit, d.LeaseStart, d.LeaseEnd, d.ClosingDate, " +
                "d.CommissionPercent, d.CommissionAmount, d.RejectReason, d.Status, " +
                "ISNULL((SELECT SUM(Amount) FROM DealPayments WHERE DealPayments.DealID = d.DealID), 0) AS Paid " +
                "FROM Deals d " +
                "WHERE d.AgentID = '" + agentId + "' ORDER BY d.DealID DESC", con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            DataTable all = ds.Tables[0];

            // ----- cards -----
            int total = 0, pending = 0;
            decimal salesValue = 0, earned = 0, paid = 0;

            foreach (DataRow r in all.Rows)
            {
                string role = r["Status"].ToString();

                if (role != "Rejected") total++;
                if (role == "Pending") pending++;

                if (role == "Approved" || role == "Paid")
                {
                    if (r["FinalPrice"] != DBNull.Value) salesValue += Convert.ToDecimal(r["FinalPrice"]);
                    if (r["CommissionAmount"] != DBNull.Value) earned += Convert.ToDecimal(r["CommissionAmount"]);
                }

                if (role == "Paid" && r["CommissionAmount"] != DBNull.Value) paid += Convert.ToDecimal(r["CommissionAmount"]);
            }

            litTotal.Text = total.ToString();
            litPending.Text = pending.ToString();
            litSalesValue.Text = Server.HtmlEncode(cur) + salesValue.ToString("N2");
            litEarned.Text = Server.HtmlEncode(cur) + earned.ToString("N2");
            litPaid.Text = Server.HtmlEncode(cur) + paid.ToString("N2");

            // ----- grid -----
            DataView view = all.DefaultView;

            // the status text comes from the dropdown's own items
            view.RowFilter = ddlStatusFilter.SelectedValue == "" ? "" : "Status = '" + q(ddlStatusFilter.SelectedValue) + "'";

            gvDeals.DataSource = view;
            gvDeals.DataBind();
        }


        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblMessage.Visible = false;
            gridfield();
        }


        // payment box: only for deals that are not rejected and still have a balance
        protected void gvDeals_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            DataRowView row = (DataRowView)e.Row.DataItem;

            Panel pnl = (Panel)e.Row.FindControl("pnlAddPay");
            bool rejected = row["Status"].ToString() == "Rejected";
            bool fullyPaid = row["DealType"].ToString() == "sale" && row["FinalPrice"] != DBNull.Value &&
                Convert.ToDecimal(row["Paid"]) >= Convert.ToDecimal(row["FinalPrice"]);

            pnl.Visible = !rejected && !fullyPaid;
        }


        protected void gvDeals_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "AddPay") return;

            int dealId;

            if (!int.TryParse(Convert.ToString(e.CommandArgument), out dealId)) return;

            GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
            TextBox txtAmt = (TextBox)row.FindControl("txtPayAmt");
            DropDownList ddl = (DropDownList)row.FindControl("ddlPayMode");
            TextBox txtRef = (TextBox)row.FindControl("txtPayRef");

            decimal amount;

            if (!decimal.TryParse(txtAmt.Text.Trim().Replace(",", ""), NumberStyles.Number, CultureInfo.InvariantCulture, out amount) || amount <= 0)
            {
                showMessage("Please enter a payment amount greater than zero.", false);
                return;
            }

            string mode = ddl.SelectedValue;

            if (mode == "")
            {
                showMessage("Please choose the payment mode.", false);
                return;
            }

            // only the agent's own deals, and never a rejected one
            getcon();

            da = new SqlDataAdapter(
                "SELECT d.DealType, d.FinalPrice, d.Status, " +
                "ISNULL((SELECT SUM(Amount) FROM DealPayments WHERE DealPayments.DealID = d.DealID), 0) AS Paid " +
                "FROM Deals d " +
                "WHERE d.DealID = '" + dealId + "' AND d.AgentID = '" + agentId + "'", con);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables[0].Rows.Count == 0 || ds.Tables[0].Rows[0]["Status"].ToString() == "Rejected")
            {
                con.Close();
                showMessage("This deal cannot take payments.", false);
                return;
            }

            DataRow d = ds.Tables[0].Rows[0];

            if (d["DealType"].ToString() == "sale" && d["FinalPrice"] != DBNull.Value)
            {
                decimal balance = Convert.ToDecimal(d["FinalPrice"]) - Convert.ToDecimal(d["Paid"]);

                if (amount > balance)
                {
                    con.Close();
                    showMessage("The payment is more than the balance (" + cur + balance.ToString("N2") + ").", false);
                    return;
                }
            }

            string reference = txtRef.Text.Trim();

            cmd = new SqlCommand(
                "INSERT INTO DealPayments (DealID, PaymentDate, Amount, PaymentMode, Reference) VALUES('" + dealId + "','" +
                DateTime.Today.ToString("yyyyMMdd") + "'," + amount.ToString(CultureInfo.InvariantCulture) + ",'" + q(mode) + "'," +
                (reference == "" ? "NULL" : "'" + q(reference) + "'") + ")", con);
            cmd.ExecuteNonQuery();

            con.Close();

            showMessage("Payment added.", true);
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
            string t = Convert.ToString(type);
            return Server.HtmlEncode(t == "" ? "" : "For " + char.ToUpper(t[0]) + t.Substring(1));
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

            return "Listed: " + money(r["ListedPrice"]) + "<br />Final: <strong>" + money(r["FinalPrice"]) + "</strong><br />" +
                "<span class=\"muted\">Closing " + date(r["ClosingDate"]) + "</span>";
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

            if (r["CommissionAmount"] == DBNull.Value) return "<span class=\"muted\">After approval</span>";

            return "<strong>" + money(r["CommissionAmount"]) + "</strong><br /><span class=\"muted\">" +
                Convert.ToDecimal(r["CommissionPercent"]).ToString("0.##") + "%</span>";
        }


        protected string ReasonHtml(object reason)
        {
            string t = Convert.ToString(reason).Trim();
            return t == "" ? "" : "<div class=\"muted\">Reason: " + Server.HtmlEncode(t) + "</div>";
        }
    }
}

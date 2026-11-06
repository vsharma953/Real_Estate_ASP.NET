using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

namespace Real_Estate.SiteAdmin
{
    public partial class DealDetail : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        string cur = "$";


        int dealId
        {
            get
            {
                int id;
                return int.TryParse(Request.QueryString["id"], out id) ? id : 0;
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadDeal();
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


        string h(object value)
        {
            return Server.HtmlEncode(Convert.ToString(value));
        }


        string money(object v)
        {
            return v == null || v == DBNull.Value ? "-" : Server.HtmlEncode(cur) + Convert.ToDecimal(v).ToString("N2");
        }


        string date(object v)
        {
            return v == null || v == DBNull.Value ? "-" : Convert.ToDateTime(v).ToString("dd/MM/yyyy");
        }


        protected string Money(object v)
        {
            return money(v);
        }


        void showMessage(string text)
        {
            lblMessage.Text = Server.HtmlEncode(text);
            lblMessage.Visible = true;
        }


        void loadDeal()
        {
            getcon();

            da = new SqlDataAdapter(
                "SELECT d.*, ISNULL(a.FullName, 'Unassigned') AS AgentName, a.Email AS AgentEmail, a.Phone AS AgentPhone, " +
                "i.Message AS InquiryMessage, i.InquiryDate, i.AgentNote, " +
                "ISNULL((SELECT SUM(Amount) FROM DealPayments WHERE DealPayments.DealID = d.DealID), 0) AS Paid " +
                "FROM Deals d " +
                "LEFT JOIN Agents a ON a.AgentID = d.AgentID " +
                "LEFT JOIN Inquiries i ON i.InquiryID = d.InquiryID " +
                "WHERE d.DealID = '" + dealId + "'", con);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables[0].Rows.Count == 0)
            {
                con.Close();
                pnlDeal.Visible = false;
                showMessage("This deal was not found.");
                return;
            }

            DataRow d = ds.Tables[0].Rows[0];

            // payments
            da = new SqlDataAdapter(
                "SELECT p.PaymentDate, p.Amount, p.PaymentMode AS ModeName, p.Reference FROM DealPayments p " +
                "WHERE p.DealID = '" + dealId + "' ORDER BY p.PaymentDate, p.PaymentID", con);
            DataSet pay = new DataSet();
            da.Fill(pay);

            con.Close();

            gvPayments.DataSource = pay;
            gvPayments.DataBind();

            string type = d["DealType"].ToString();
            string role = d["Status"].ToString();
            bool isRent = type == "rent";
            decimal paid = Convert.ToDecimal(d["Paid"]);

            litTitle.Text = "Deal #" + dealId + ": " + h(d["PropertyTitle"]);
            litStatus.Text = h(d["Status"]);
            litSubtitle.Text = (isRent ? "Rental" : "Sale") + " recorded on " + date(d["CreatedOn"]) +
                (d["ReviewedOn"] == DBNull.Value ? "" : " | reviewed on " + date(d["ReviewedOn"]) +
                (Convert.ToString(d["ReviewedBy"]) == "" ? "" : " by " + h(d["ReviewedBy"])));

            litAgent.Text = "<strong>" + h(d["AgentName"]) + "</strong><br />" + h(d["AgentEmail"]) + "<br />" + h(d["AgentPhone"]);

            litClient.Text = "<strong>" + h(d["ClientName"]) + "</strong><br />" + h(d["ClientPhone"]) + "<br />" + h(d["ClientEmail"]) +
                (Convert.ToString(d["ClientAddress"]) == "" ? "" : "<br />" + h(d["ClientAddress"]));

            litProperty.Text = "<strong>" + h(d["PropertyTitle"]) + "</strong><br />" + h(d["PropertyType"]) + "<br />" + h(d["PropertyLocation"]) +
                "<br />Listed price: " + money(d["ListedPrice"]);

            if (isRent)
            {
                litTerms.Text = "Monthly rent: <strong>" + money(d["MonthlyRent"]) + "</strong><br />Security deposit: " + money(d["SecurityDeposit"]) +
                    "<br />Lease: " + date(d["LeaseStart"]) + " to " + date(d["LeaseEnd"]);
                litMoney.Text = "Received so far: <strong>" + money(paid) + "</strong>";
                litCommission.Text = "<span class=\"muted\">Rentals do not earn commission.</span>";
            }
            else
            {
                decimal finalPrice = d["FinalPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(d["FinalPrice"]);
                string discount = "";

                if (d["ListedPrice"] != DBNull.Value && Convert.ToDecimal(d["ListedPrice"]) > finalPrice)
                {
                    discount = "<br />Discount from listed price: " + money(Convert.ToDecimal(d["ListedPrice"]) - finalPrice);
                }

                litTerms.Text = "Final price: <strong>" + money(finalPrice) + "</strong>" + discount +
                    "<br />Agreement date: " + date(d["AgreementDate"]) + "<br />Closing date: " + date(d["ClosingDate"]);
                litMoney.Text = "Received so far: <strong>" + money(paid) + "</strong><br />Balance: " + money(finalPrice - paid);

                if (d["CommissionAmount"] == DBNull.Value)
                {
                    litCommission.Text = "<span class=\"muted\">Calculated when the deal is approved.</span>";
                }
                else
                {
                    litCommission.Text = "Rate: " + Convert.ToDecimal(d["CommissionPercent"]).ToString("0.##") + "%<br />Amount: <strong>" +
                        money(d["CommissionAmount"]) + "</strong>" +
                        (d["CommissionPaidOn"] == DBNull.Value ? "" : "<br />Paid on " + date(d["CommissionPaidOn"]));
                }
            }

            string notes = "";

            if (Convert.ToString(d["InquiryMessage"]) != "")
            {
                notes += "<div class=\"muted\">Client's inquiry (" + date(d["InquiryDate"]) + ")</div><div class=\"quote\">" + h(d["InquiryMessage"]) + "</div>";
            }

            if (Convert.ToString(d["AgentNote"]) != "")
            {
                notes += "<div class=\"muted\" style=\"margin-top:8px\">Agent's inquiry note</div><div class=\"quote\">" + h(d["AgentNote"]) + "</div>";
            }

            if (Convert.ToString(d["Notes"]) != "")
            {
                notes += "<div class=\"muted\" style=\"margin-top:8px\">Notes on the deal</div><div class=\"quote\">" + h(d["Notes"]) + "</div>";
            }

            if (Convert.ToString(d["RejectReason"]) != "")
            {
                notes += "<div class=\"muted\" style=\"margin-top:8px\">Rejected because</div><div class=\"quote\">" + h(d["RejectReason"]) + "</div>";
            }

            litNotes.Text = notes == "" ? "<span class=\"muted\">Nothing recorded.</span>" : notes;

            // which actions make sense for this deal
            pnlReview.Visible = role == "Pending";
            pnlPaid.Visible = role == "Approved" && !isRent;
        }


        string reviewer
        {
            get { return Convert.ToString(Session["SiteAdminEmail"]); }
        }


        // ---------- Approve: work out the commission and confirm the deal ----------
        protected void btnApprove_Click(object sender, EventArgs e)
        {
            getcon();

            da = new SqlDataAdapter(
                "SELECT d.FinalPrice, d.AgentID, a.CommissionPercent " +
                "FROM Deals d LEFT JOIN Agents a ON a.AgentID = d.AgentID " +
                "WHERE d.DealID = '" + dealId + "' AND d.Status = 'Pending'", con);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables[0].Rows.Count == 0)
            {
                con.Close();
                showMessage("This deal is no longer waiting for approval.");
                loadDeal();
                return;
            }

            DataRow d = ds.Tables[0].Rows[0];

            // the agent's own commission rate (set on the Manage Agents page)
            decimal rate = d["CommissionPercent"] == DBNull.Value ? 0 : Convert.ToDecimal(d["CommissionPercent"]);

            decimal finalPrice = d["FinalPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(d["FinalPrice"]);
            decimal amount = Math.Round(finalPrice * rate / 100m, 2);

            cmd = new SqlCommand(
                "UPDATE Deals SET Status = 'Approved', " +
                "CommissionPercent = " + rate.ToString(CultureInfo.InvariantCulture) + ", " +
                "CommissionAmount = " + amount.ToString(CultureInfo.InvariantCulture) + ", " +
                "ReviewedOn = GETDATE(), ReviewedBy = '" + q(reviewer) + "' " +
                "WHERE DealID = '" + dealId + "'", con);
            cmd.ExecuteNonQuery();

            con.Close();

            showMessage("Deal approved. Commission " + cur + amount.ToString("N2") + " (" + rate.ToString("0.##") + "%).");
            loadDeal();
        }


        // ---------- Reject: the deal is cancelled and the property goes back on the website ----------
        protected void btnReject_Click(object sender, EventArgs e)
        {
            string reason = txtReason.Text.Trim();

            if (reason == "")
            {
                showMessage("Please write the reason for rejecting this deal.");
                return;
            }

            getcon();

            SqlTransaction tran = con.BeginTransaction();

            try
            {
                cmd = new SqlCommand(
                    "SELECT d.PropertyID FROM Deals d " +
                    "WHERE d.DealID = '" + dealId + "' AND d.Status = 'Pending'", con, tran);
                da = new SqlDataAdapter(cmd);
                ds = new DataSet();
                da.Fill(ds);

                if (ds.Tables[0].Rows.Count == 0)
                {
                    tran.Rollback();
                    con.Close();
                    showMessage("This deal is no longer waiting for approval.");
                    loadDeal();
                    return;
                }

                cmd = new SqlCommand(
                    "UPDATE Deals SET Status = 'Rejected', " +
                    "RejectReason = '" + q(reason) + "', ReviewedOn = GETDATE(), ReviewedBy = '" + q(reviewer) + "' " +
                    "WHERE DealID = '" + dealId + "'", con, tran);
                cmd.ExecuteNonQuery();

                object propertyId = ds.Tables[0].Rows[0]["PropertyID"];

                if (propertyId != DBNull.Value)
                {
                    cmd = new SqlCommand(
                        "UPDATE Properties SET Status = 'Available' " +
                        "WHERE PropertyID = '" + propertyId + "'", con, tran);
                    cmd.ExecuteNonQuery();
                }

                tran.Commit();
                con.Close();

                txtReason.Text = "";
                showMessage("Deal rejected. The property is available again.");
                loadDeal();
            }
            catch (SqlException)
            {
                tran.Rollback();
                con.Close();
                showMessage("The deal could not be rejected. Please try again.");
            }
        }


        // ---------- Commission paid ----------
        protected void btnMarkPaid_Click(object sender, EventArgs e)
        {
            getcon();

            cmd = new SqlCommand(
                "UPDATE Deals SET Status = 'Paid', CommissionPaidOn = GETDATE() " +
                "WHERE DealID = '" + dealId + "' AND DealType = 'sale' AND Status = 'Approved'", con);
            int changed = cmd.ExecuteNonQuery();

            con.Close();

            showMessage(changed > 0 ? "Commission marked as paid." : "This deal is not waiting for a commission payment.");
            loadDeal();
        }
    }
}

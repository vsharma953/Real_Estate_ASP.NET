using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;

namespace Real_Estate.Admin
{
    public partial class CloseDeal : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        // used by the page markup
        protected string Cur = "$";

        // a property is open for a deal while its Status is Available
        string openFilter = " LTRIM(RTRIM(p.Status)) = 'Available' ";


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
                loadContext();
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


        string sqlText(string value)
        {
            return value == "" ? "NULL" : "'" + q(value) + "'";
        }


        string sqlDate(DateTime? d)
        {
            return d.HasValue ? "'" + d.Value.ToString("yyyyMMdd") + "'" : "NULL";
        }


        string sqlNum(decimal v)
        {
            return v.ToString(CultureInfo.InvariantCulture);
        }


        void showMessage(string text)
        {
            lblMessage.Text = Server.HtmlEncode(text);
            lblMessage.Visible = true;
        }


        void fail(string text)
        {
            showMessage(text);
            pnlForm.Visible = false;
            hlBackOnly.Visible = true;
        }


        // price text such as "450000", "$450,000" or "450,000.50" -> number (0 when unreadable)
        decimal parsePrice(object value)
        {
            string price = Regex.Replace(Convert.ToString(value), @"[.,]\d{1,2}$", "");
            price = Regex.Replace(price, @"\D", "");

            decimal result;
            return decimal.TryParse(price, out result) ? result : 0;
        }


        // Which property and client is this deal for? (from an inquiry, or straight from a property)
        void loadContext()
        {
            int inquiryId = 0, propertyId = 0;
            int.TryParse(Request.QueryString["InquiryID"], out inquiryId);
            int.TryParse(Request.QueryString["PropertyID"], out propertyId);

            string name = "", email = "", phone = "";

            if (inquiryId > 0)
            {
                getcon();

                da = new SqlDataAdapter(
                    "SELECT i.FullName, i.Email, i.Phone, i.PropertyID, ISNULL(i.AssignedAgentID, p.AgentID) AS OwnerID " +
                    "FROM Inquiries i LEFT JOIN Properties p ON p.PropertyID = i.PropertyID " +
                    "WHERE i.InquiryID = '" + inquiryId + "'", con);
                ds = new DataSet();
                da.Fill(ds);

                con.Close();

                if (ds.Tables[0].Rows.Count == 0 || Convert.ToString(ds.Tables[0].Rows[0]["OwnerID"]) != agentId.ToString())
                {
                    fail("This inquiry was not found.");
                    return;
                }

                DataRow inq = ds.Tables[0].Rows[0];

                if (inq["PropertyID"] == DBNull.Value)
                {
                    fail("This inquiry is not linked to a property. Close the deal from the property's row on the Properties page instead.");
                    return;
                }

                propertyId = Convert.ToInt32(inq["PropertyID"]);
                name = inq["FullName"].ToString();
                email = inq["Email"].ToString();
                phone = inq["Phone"].ToString();
            }

            if (propertyId <= 0)
            {
                fail("No property was selected.");
                return;
            }

            // from an inquiry the agent owns the lead; otherwise the property itself must be theirs
            string ownerCheck = inquiryId > 0 ? "" : " AND p.AgentID = '" + agentId + "'";

            getcon();

            da = new SqlDataAdapter(
                "SELECT p.PropertyID, p.Title, p.Location, p.PropertyType, p.ListingType, p.Price FROM Properties p " +
                "WHERE p.PropertyID = '" + propertyId + "'" + ownerCheck + " AND" + openFilter, con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            if (ds.Tables[0].Rows.Count == 0)
            {
                fail("This property is not available: it may already be sold or rented, or it is not yours.");
                return;
            }

            DataRow p = ds.Tables[0].Rows[0];

            string key = p["ListingType"].ToString().Trim().ToLower();
            decimal price = parsePrice(p["Price"]);

            ViewState["PropertyID"] = propertyId;
            ViewState["InquiryID"] = inquiryId;
            ViewState["Listing"] = key;

            lblProperty.Text = Server.HtmlEncode(p["Title"].ToString());
            lblMeta.Text = Server.HtmlEncode((key == "" ? "" : "For " + char.ToUpper(key[0]) + key.Substring(1) + " | ") +
                p["PropertyType"].ToString() + " | " + p["Location"].ToString());
            lblListed.Text = Server.HtmlEncode(Cur + (price > 0 ? price.ToString("N2") : p["Price"].ToString()));

            // the listing type decides which form is shown
            pnlRent.Visible = key == "rent";
            pnlSale.Visible = !pnlRent.Visible;

            if (price > 0)
            {
                txtFinalPrice.Text = price.ToString("0.##", CultureInfo.InvariantCulture);
                txtMonthlyRent.Text = price.ToString("0.##", CultureInfo.InvariantCulture);
            }

            txtClientName.Text = name;
            txtClientEmail.Text = email;
            txtClientPhone.Text = phone;
            txtPayDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
        }


        // ---------- validation helpers ----------
        bool tryMoney(string text, out decimal value)
        {
            value = 0;
            text = text.Trim().Replace(",", "");

            if (text == "") return true;

            return decimal.TryParse(text, NumberStyles.Number, CultureInfo.InvariantCulture, out value) && value >= 0;
        }


        bool tryDate(string text, out DateTime? value)
        {
            value = null;

            if (text.Trim() == "") return true;

            DateTime d;

            if (DateTime.TryParse(text, CultureInfo.InvariantCulture, DateTimeStyles.None, out d))
            {
                value = d;
                return true;
            }

            return false;
        }


        bool validEmail(string email)
        {
            if (email.Length > 150) return false;

            try
            {
                return new MailAddress(email).Address == email;
            }
            catch (FormatException)
            {
                return false;
            }
        }


        bool validPhone(string phone)
        {
            return Regex.IsMatch(Regex.Replace(phone, @"[\s\-\.\(\)]", ""), @"^\+?\d{7,15}$");
        }


        // ---------- Submit ----------
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (ViewState["PropertyID"] == null) return;

            int propertyId = (int)ViewState["PropertyID"];
            int inquiryId = (int)ViewState["InquiryID"];
            bool isRent = ViewState["Listing"].ToString() == "rent";

            string name = txtClientName.Text.Trim();
            string email = txtClientEmail.Text.Trim();
            string phone = txtClientPhone.Text.Trim();
            string address = txtClientAddress.Text.Trim();
            string notes = txtNotes.Text.Trim();

            if (name == "") { showMessage("Please enter the client's full name."); return; }
            if (email == "" || !validEmail(email)) { showMessage("Please enter a valid client email."); return; }
            if (phone == "" || !validPhone(phone)) { showMessage("Please enter a valid client mobile number."); return; }
            if (notes.Length > 1000) { showMessage("Notes are too long (1000 characters at most)."); return; }

            decimal finalPrice = 0, rent = 0, deposit = 0, payAmount = 0;
            DateTime? closing = null, agreement = null, leaseStart = null, leaseEnd = null, payDate = null;

            if (!tryMoney(txtPayAmount.Text, out payAmount)) { showMessage("The payment amount is not a valid number."); return; }
            if (!tryDate(txtPayDate.Text, out payDate)) { showMessage("The payment date is not valid."); return; }

            if (payAmount > 0)
            {
                if (ddlPayMode.SelectedValue == "") { showMessage("Please choose the payment mode."); return; }
                if (!payDate.HasValue) payDate = DateTime.Today;
            }

            if (!isRent)
            {
                if (!tryMoney(txtFinalPrice.Text, out finalPrice) || finalPrice <= 0) { showMessage("Please enter the final agreed price."); return; }
                if (!tryDate(txtClosingDate.Text, out closing) || !closing.HasValue) { showMessage("Please enter the closing date."); return; }
                if (!tryDate(txtAgreementDate.Text, out agreement)) { showMessage("The agreement date is not valid."); return; }
                if (payAmount > finalPrice) { showMessage("The first payment cannot be more than the final price."); return; }
            }
            else
            {
                if (!tryMoney(txtMonthlyRent.Text, out rent) || rent <= 0) { showMessage("Please enter the monthly rent."); return; }
                if (!tryMoney(txtDeposit.Text, out deposit)) { showMessage("The security deposit is not a valid number."); return; }
                if (!tryDate(txtLeaseStart.Text, out leaseStart) || !leaseStart.HasValue) { showMessage("Please enter the lease start date."); return; }
                if (!tryDate(txtLeaseEnd.Text, out leaseEnd) || !leaseEnd.HasValue) { showMessage("Please enter the lease end date."); return; }
                if (leaseEnd.Value <= leaseStart.Value) { showMessage("The lease end date must be after the lease start date."); return; }
            }

            getcon();

            SqlTransaction tran = con.BeginTransaction();

            try
            {
                // the property must still be open (and the agent's own, unless the deal comes from their inquiry)
                string ownerCheck = inquiryId > 0 ? "" : " AND p.AgentID = '" + agentId + "'";

                cmd = new SqlCommand("SELECT p.Title, p.Location, p.PropertyType, p.Price FROM Properties p WHERE p.PropertyID = '" + propertyId + "'" + ownerCheck + " AND" + openFilter, con, tran);
                da = new SqlDataAdapter(cmd);
                ds = new DataSet();
                da.Fill(ds);

                if (ds.Tables[0].Rows.Count == 0)
                {
                    tran.Rollback();
                    con.Close();
                    fail("This property has just been closed or is no longer available.");
                    return;
                }

                DataRow p = ds.Tables[0].Rows[0];
                decimal listed = parsePrice(p["Price"]);

                // a sale becomes Sold and waits for approval; a rental becomes Rented and is approved straight away
                string closedName = isRent ? "Rented" : "Sold";
                string dealStatus = isRent ? "Approved" : "Pending";

                cmd = new SqlCommand(
                    "INSERT INTO Deals (DealType, PropertyID, InquiryID, AgentID, PropertyTitle, PropertyLocation, PropertyType, ListedPrice, " +
                    "ClientName, ClientEmail, ClientPhone, ClientAddress, FinalPrice, AgreementDate, ClosingDate, " +
                    "MonthlyRent, SecurityDeposit, LeaseStart, LeaseEnd, Status, Notes, ReviewedOn) " +
                    "VALUES('" + (isRent ? "rent" : "sale") + "','" + propertyId + "'," + (inquiryId > 0 ? "'" + inquiryId + "'" : "NULL") + ",'" + agentId + "'," +
                    sqlText(p["Title"].ToString()) + "," + sqlText(p["Location"].ToString()) + "," + sqlText(p["PropertyType"].ToString()) + "," + (listed > 0 ? sqlNum(listed) : "NULL") + "," +
                    sqlText(name) + "," + sqlText(email) + "," + sqlText(phone) + "," + sqlText(address) + "," +
                    (isRent ? "NULL" : sqlNum(finalPrice)) + "," + (isRent ? "NULL" : sqlDate(agreement)) + "," + (isRent ? "NULL" : sqlDate(closing)) + "," +
                    (isRent ? sqlNum(rent) : "NULL") + "," + (isRent ? sqlNum(deposit) : "NULL") + "," + (isRent ? sqlDate(leaseStart) : "NULL") + "," + (isRent ? sqlDate(leaseEnd) : "NULL") + "," +
                    "'" + dealStatus + "'," + sqlText(notes) + "," + (isRent ? "GETDATE()" : "NULL") + "); " +
                    "SELECT SCOPE_IDENTITY()", con, tran);

                int dealId = Convert.ToInt32(cmd.ExecuteScalar());

                if (payAmount > 0)
                {
                    cmd = new SqlCommand(
                        "INSERT INTO DealPayments (DealID, PaymentDate, Amount, PaymentMode, Reference) VALUES('" + dealId + "'," +
                        sqlDate(payDate) + "," + sqlNum(payAmount) + "," + sqlText(ddlPayMode.SelectedValue) + "," + sqlText(txtPayRef.Text.Trim()) + ")", con, tran);
                    cmd.ExecuteNonQuery();
                }

                // the property leaves the website straight away
                cmd = new SqlCommand("UPDATE Properties SET Status = '" + q(closedName) + "' WHERE PropertyID = '" + propertyId + "'", con, tran);
                cmd.ExecuteNonQuery();

                tran.Commit();
                con.Close();

                Response.Redirect("MyDeals.aspx?saved=" + dealId);
            }
            catch (SqlException)
            {
                tran.Rollback();
                con.Close();
                showMessage("The deal could not be saved. Please check the values and try again.");
            }
        }
    }
}

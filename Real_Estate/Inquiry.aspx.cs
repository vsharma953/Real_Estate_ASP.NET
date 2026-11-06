using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;

namespace Real_Estate
{
    public partial class Inquiry : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        // a property is open for inquiries while its Status is Available
        string openFilter = " LTRIM(RTRIM(p.Status)) = 'Available' ";


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadProperties();
                prefillVisitor();
                preselectProperty();
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        // makes text safe inside '...' (an apostrophe in a name or message would break the query)
        string q(string value)
        {
            return value.Replace("'", "''");
        }


        // ---------- Property dropdown ----------
        void loadProperties()
        {
            ddlProperty.Items.Clear();
            ddlProperty.Items.Add(new ListItem("General inquiry (no specific property)", "0"));

            getcon();

            da = new SqlDataAdapter("SELECT p.PropertyID, p.Title, p.Location FROM Properties p WHERE" + openFilter + "ORDER BY p.Title", con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            foreach (DataRow r in ds.Tables[0].Rows)
            {
                string text = r["Title"].ToString();
                string loc = r["Location"].ToString().Trim();

                if (loc != "") text += " - " + loc;

                ddlProperty.Items.Add(new ListItem(text, r["PropertyID"].ToString()));
            }
        }


        // Property chosen on the Properties page: lock it so the inquiry
        // always reaches the right agent.
        void preselectProperty()
        {
            int id;

            if (!int.TryParse(Request.QueryString["PropertyID"], out id) || id <= 0) return;

            ListItem item = ddlProperty.Items.FindByValue(id.ToString());

            if (item == null)
            {
                showMessage("This property is no longer available. You can choose another property or send a general inquiry.", false);
                return;
            }

            ddlProperty.ClearSelection();
            item.Selected = true;
            ddlProperty.Enabled = false;
            hlChangeProperty.Visible = true;
            ViewState["LockedPropertyID"] = id;
        }


        // ---------- Logged-in visitor details ----------
        void prefillVisitor()
        {
            if (Session["UserID"] == null)
            {
                return;
            }

            int userId;

            if (int.TryParse(Session["UserID"].ToString(), out userId))
            {
                getcon();

                da = new SqlDataAdapter("SELECT FullName, Email, Phone FROM Users WHERE UserID = '" + userId + "'", con);
                ds = new DataSet();
                da.Fill(ds);

                con.Close();

                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    txtName.Text = ds.Tables[0].Rows[0]["FullName"].ToString();
                    txtEmail.Text = ds.Tables[0].Rows[0]["Email"].ToString();
                    txtPhone.Text = ds.Tables[0].Rows[0]["Phone"].ToString();
                }
            }

            if (txtName.Text == "" && Session["FullName"] != null)
            {
                txtName.Text = Session["FullName"].ToString();
            }

            if (txtName.Text != "")
            {
                txtName.ReadOnly = true;
                txtName.CssClass = "form-control form-control-readonly";
            }
        }


        // ---------- Helpers ----------
        void showMessage(string text, bool success)
        {
            lblMessage.Text = Server.HtmlEncode(text);
            lblMessage.CssClass = "inquiry-message " + (success ? "success-message" : "error-message");
            lblMessage.Visible = true;
        }


        bool validEmail(string email)
        {
            if (email.Length > 150) return false;

            try
            {
                MailAddress m = new MailAddress(email);
                return m.Address == email;
            }
            catch (FormatException)
            {
                return false;
            }
        }


        bool validPhone(string phone)
        {
            string digits = Regex.Replace(phone, @"[\s\-\.\(\)]", "");
            return Regex.IsMatch(digits, @"^\+?\d{7,15}$");
        }


        // ---------- Submit ----------
        protected void btnSubmitInquiry_Click(object sender, EventArgs e)
        {
            string name = Session["FullName"] != null && txtName.ReadOnly
                ? Session["FullName"].ToString().Trim()
                : txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string message = txtMessage.Text.Trim();

            if (name == "")
            {
                showMessage("Please enter your full name.", false);
                return;
            }

            if (email == "" || !validEmail(email))
            {
                showMessage("Please enter a valid email address.", false);
                return;
            }

            if (phone == "" || !validPhone(phone))
            {
                showMessage("Please enter a valid mobile number (7 to 15 digits).", false);
                return;
            }

            if (message == "")
            {
                showMessage("Please enter your message.", false);
                return;
            }

            if (message.Length > 1000)
            {
                showMessage("Your message is too long. Please keep it under 1000 characters.", false);
                return;
            }

            // Locked property (came from the Properties page) or the dropdown choice
            int propertyId = 0;

            if (ViewState["LockedPropertyID"] != null)
            {
                propertyId = (int)ViewState["LockedPropertyID"];
            }
            else
            {
                int.TryParse(ddlProperty.SelectedValue, out propertyId);
            }

            // The title saved with the inquiry always comes from the database,
            // never from the browser.
            string propertyTitle = "General Property Inquiry";
            string pid = "NULL";

            if (propertyId > 0)
            {
                getcon();

                cmd = new SqlCommand("SELECT p.Title FROM Properties p WHERE p.PropertyID = '" + propertyId + "' AND" + openFilter, con);
                object title = cmd.ExecuteScalar();

                con.Close();

                if (title == null)
                {
                    showMessage("This property is no longer available. Please choose another property or send a general inquiry.", false);
                    return;
                }

                propertyTitle = title.ToString();
                pid = "'" + propertyId + "'";
            }

            getcon();

            cmd = new SqlCommand(
                "INSERT INTO Inquiries (FullName, Email, Phone, Property, PropertyID, Message, InquiryDate) " +
                "VALUES('" +
                q(name) + "','" +
                q(email) + "','" +
                q(phone) + "','" +
                q(propertyTitle) + "'," +
                pid + ",'" +
                q(message) + "','" +
                DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')", con);

            cmd.ExecuteNonQuery();

            con.Close();

            showMessage("Thank you. Your inquiry has been sent and the agent will contact you soon.", true);

            txtMessage.Text = "";

            // guests start with a clean form, logged-in visitors keep their details
            if (Session["UserID"] == null)
            {
                txtName.Text = "";
                txtEmail.Text = "";
                txtPhone.Text = "";
            }
        }
    }
}

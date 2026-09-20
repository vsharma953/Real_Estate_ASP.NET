using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Real_Estate
{
    public partial class Inquiry : System.Web.UI.Page
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
                if (Session["FullName"] != null)
                {
                    txtName.Text = Session["FullName"].ToString();
                    txtName.ReadOnly = true;
                    txtName.CssClass = "form-control form-control-readonly";
                }
                else
                {
                    txtName.ReadOnly = false;
                    txtName.CssClass = "form-control";
                }


                string targetProperty = Request.QueryString["Property"];

                if (!string.IsNullOrEmpty(targetProperty))
                {
                    txtMessage.Text ="I am interested in acquiring details for: " + targetProperty + "Please contact me at your earliest convenience.";
                }
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        protected void btnSubmitInquiry_Click(object sender, EventArgs e)
        {
            if (txtName.Text == "")
            {
                lblMessage.Text = "Please enter your full name.";
                lblMessage.Visible = true;
                return;
            }


            if (txtPhone.Text == "")
            {
                lblMessage.Text = "Please enter your phone number.";
                lblMessage.Visible = true;
                return;
            }


            if (txtMessage.Text == "")
            {
                lblMessage.Text = "Please enter your message.";
                lblMessage.Visible = true;
                return;
            }


            string propertyName = Request.QueryString["Property"];


            if (string.IsNullOrEmpty(propertyName))
            {
                propertyName = "General Property Inquiry";
            }
            getcon();

            cmd = new SqlCommand("INSERT INTO Inquiries(FullName, Phone, Property, Message, InquiryDate) VALUES('" + txtName.Text + "', '" + txtPhone.Text + "', '" + propertyName + "', '" + txtMessage.Text + "', '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')",con);
            cmd.ExecuteNonQuery();

            con.Close();

            lblMessage.Text = "Your inquiry has been submitted successfully.";
            lblMessage.Visible = true;


            txtPhone.Text = "";
            txtMessage.Text = "";
        }
    }
}
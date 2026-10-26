using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Real_Estate
{
    public partial class LoginRegister : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            getcon();

            cmd = new SqlCommand("SELECT * FROM Users WHERE Email = '" + txtLoginEmail.Text + "' AND Password = '" + txtLoginPassword.Text + "'", con);

            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                Session["UserID"] = ds.Tables[0].Rows[0]["UserID"].ToString();
                Session["FullName"] = ds.Tables[0].Rows[0]["FullName"].ToString();

                Response.Redirect("Account.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            else
            {
                showLoginMessage("Invalid Email or Password.");
            }

            con.Close();
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (txtRegisterName.Text == "" || txtRegisterEmail.Text == "" || txtRegisterPhone.Text == "" || txtRegisterPassword.Text == "" || txtConfirmPassword.Text == "")
            {
                showRegisterMessage("Please fill all fields.");
                return;
            }

            if (txtRegisterPassword.Text != txtConfirmPassword.Text)
            {
                showRegisterMessage("Passwords do not match.");
                return;
            }

            getcon();

            cmd = new SqlCommand("SELECT * FROM Users WHERE Email = '" + txtRegisterEmail.Text + "'", con);
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                showRegisterMessage("Email already registered.");
                con.Close();
                return;
            }

            cmd = new SqlCommand("INSERT INTO Users(FullName, Email, Phone, Password) VALUES('" + txtRegisterName.Text + "', '" + txtRegisterEmail.Text + "', '" + txtRegisterPhone.Text + "', '" + txtRegisterPassword.Text + "')", con);
            cmd.ExecuteNonQuery();

            cmd = new SqlCommand("SELECT UserID, FullName FROM Users WHERE Email = '" + txtRegisterEmail.Text + "'", con);

            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                Session["UserID"] = ds.Tables[0].Rows[0]["UserID"].ToString();
                Session["FullName"] = ds.Tables[0].Rows[0]["FullName"].ToString();

                Response.Redirect("Account.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            else
            {
                showRegisterMessage("Registration completed, but your account could not be opened. Please login.");
            }
        }
        void clear()
        {
            txtRegisterName.Text = "";
            txtRegisterEmail.Text = "";
            txtRegisterPhone.Text = "";
            txtRegisterPassword.Text = "";
            txtConfirmPassword.Text = "";
        }

        void showLoginMessage(string message)
        {
            lblLoginMessage.Text = message;
            lblLoginMessage.CssClass = "auth-message visible";
        }

        void showRegisterMessage(string message)
        {
            lblRegisterMessage.Text = message;
            lblRegisterMessage.CssClass = "auth-message visible";

            ClientScript.RegisterStartupScript(GetType(),"showRegister","toggleAuth('register');", true);
        }
    }
}
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Real_Estate
{
    public partial class Account : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("LoginRegister.aspx");
                return;
            }

            if (!IsPostBack)
            {
                loadUser();
            }
        }

        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }

        void loadUser()
        {
            getcon();

            cmd = new SqlCommand("SELECT * FROM Users WHERE UserID = '" + Session["UserID"].ToString() + "'", con);
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                lblFirstName.Text = ds.Tables[0].Rows[0]["FullName"].ToString();
                lblEmail.Text = ds.Tables[0].Rows[0]["Email"].ToString();
            }

            con.Close();
        }

        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = true;
            lblMessage.CssClass = "message error-message";


            if (txtCurrentPassword.Text == "" || txtNewPassword.Text == "" || txtConfirmPassword.Text == "")
            {
                lblMessage.Text = "Please fill in all password fields.";
                return;
            }

            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                lblMessage.Text = "New password and confirm password do not match.";
                return;
            }

            if (txtNewPassword.Text.Length < 6)
            {
                lblMessage.Text = "Password must be at least 6 characters long.";
                return;
            }

            getcon();

            cmd = new SqlCommand("SELECT * FROM Users WHERE UserID = '" + Session["UserID"].ToString() + "' AND Password = '" + txtCurrentPassword.Text + "'", con);

            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                cmd = new SqlCommand("UPDATE Users SET Password = '" + txtNewPassword.Text + "' WHERE UserID = '" + Session["UserID"].ToString() + "'", con);

                int result = cmd.ExecuteNonQuery();

                if (result > 0)
                {
                    lblMessage.CssClass = "message success-message";
                    lblMessage.Text = "Password updated successfully.";
                    txtCurrentPassword.Text = "";
                    txtNewPassword.Text = "";
                    txtConfirmPassword.Text = "";
                }
                else
                {
                    lblMessage.Text = "Password could not be updated.";
                }
            }
            else
            {
                lblMessage.Text = "Current password is incorrect.";   
            }
            con.Close();
        }

        protected void btnShowDelete_Click(object sender, EventArgs e)
        {
            pnlDeleteConfirm.Visible = true;
            btnShowDelete.Visible = false;
            lblDeleteMessage.Visible = false;
            txtDeletePassword.Text = "";
        }

        protected void btnCancelDelete_Click(object sender, EventArgs e)
        {
            pnlDeleteConfirm.Visible = false;
            btnShowDelete.Visible = true;
            txtDeletePassword.Text = "";
            lblDeleteMessage.Visible = false;
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            lblDeleteMessage.Visible = true;

            if (txtDeletePassword.Text == "")
            {
                lblDeleteMessage.CssClass = "delete-message error-delete-message";
                lblDeleteMessage.Text = "Please enter your current password.";
                return;
            }

            getcon();

            cmd = new SqlCommand("SELECT * FROM Users WHERE UserID = '" + Session["UserID"].ToString() + "' AND Password = '" + txtDeletePassword.Text + "'", con);

            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                string userID = Session["UserID"].ToString();

                cmd = new SqlCommand("DELETE FROM Users WHERE UserID = '" + userID + "'", con);
                int result = cmd.ExecuteNonQuery();

                con.Close();

                if (result > 0)
                {
                    Session.Clear();
                    Session.Abandon();

                    if (Request.Cookies["UserID"] != null)
                    {
                        Response.Cookies["UserID"].Expires = DateTime.Now.AddDays(-1);
                    }

                    if (Request.Cookies["FullName"] != null)
                    {
                        Response.Cookies["FullName"].Expires = DateTime.Now.AddDays(-1);
                    }

                    Response.Redirect("LoginRegister.aspx?deleted=1");
                }
                else
                {
                    lblDeleteMessage.CssClass = "delete-message error-delete-message";
                    lblDeleteMessage.Text = "Account could not be deleted. Please try again.";
                }
            }
            else
            {
                con.Close();

                lblDeleteMessage.CssClass = "delete-message error-delete-message";
                lblDeleteMessage.Text = "The current password you entered is incorrect.";
            }
        }
    }
}

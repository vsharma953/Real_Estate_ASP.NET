using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Real_Estate.Admin
{
    public partial class Login : System.Web.UI.Page
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
                lblError.Visible = false;
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                getcon();

                cmd = new SqlCommand("SELECT * FROM Agents WHERE Email = '" + txtEmail.Text + "' AND Password = '" + txtPassword.Text + "'", con);

                da = new SqlDataAdapter(cmd);
                ds = new DataSet();
                da.Fill(ds);

                con.Close();

                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    if (ds.Tables[0].Rows[0]["Status"].ToString() == "Active")
                    {
                        Session["AdminEmail"] = ds.Tables[0].Rows[0]["Email"].ToString();
                        Session["AgentID"] = ds.Tables[0].Rows[0]["AgentID"].ToString();
                        Session["AgentName"] = ds.Tables[0].Rows[0]["FullName"].ToString();

                        Response.Redirect("Dashboard.aspx");
                    }
                    else
                    {
                        lblError.Text = "This agent account is inactive. Please contact the site administrator.";
                        lblError.Visible = true;
                    }
                }
                else
                {
                    lblError.Text = "Invalid credentials. Please contact IT desk.";
                    lblError.Visible = true;
                }
            }
        }
    }
}

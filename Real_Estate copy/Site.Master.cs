using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Real_Estate
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                checkLogin();
            }
        }
        void checkLogin()
        {
            if (Session["UserID"] != null)
            {
                pnlRegister.Visible = false;
                pnlAccount.Visible = true;
                pnlLogout.Visible = true;
            }
            else
            {
                pnlRegister.Visible = true;
                pnlAccount.Visible = false;
                pnlLogout.Visible = false;
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            if (Request.Cookies["UserID"] != null)
            {
                Response.Cookies["UserID"].Expires = DateTime.Now.AddDays(-1);
            }

            if (Request.Cookies["FullName"] != null)
            {
                Response.Cookies["FullName"].Expires = DateTime.Now.AddDays(-1);
            }

            Session.Clear();
            Session.Abandon();

            Response.Redirect("Default.aspx");
        }
    }
}
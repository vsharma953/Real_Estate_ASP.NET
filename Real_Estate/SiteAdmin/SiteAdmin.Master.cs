using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Real_Estate.SiteAdmin
{
    public partial class SiteAdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["SiteAdminEmail"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                litAdminName.Text = Session["SiteAdminEmail"].ToString();
            }
        }
    }
}

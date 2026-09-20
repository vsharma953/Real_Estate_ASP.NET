using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Real_Estate.Admin
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminEmail"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else if (Session["AgentName"] != null)
            {
                string name = Session["AgentName"].ToString();
                string[] parts = name.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

                litAgentName.Text = name;

                if (parts.Length > 1)
                {
                    litAgentInitials.Text = (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
                }
                else if (parts.Length == 1)
                {
                    litAgentInitials.Text = parts[0].Substring(0, 1).ToUpper();
                }
            }
        }
    }
}
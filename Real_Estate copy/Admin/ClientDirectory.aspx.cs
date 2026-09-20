using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;

namespace Real_Estate.Admin
{
    public partial class ClientDirectory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
            }
        }
        protected void gvClients_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                string clientId = e.CommandArgument.ToString();
            }
            else if (e.CommandName == "DeleteRow")
            {
                string clientId = e.CommandArgument.ToString();
            }
        }
    }
}
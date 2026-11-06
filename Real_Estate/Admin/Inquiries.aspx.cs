using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Real_Estate.Admin
{
    public partial class Inquiries : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;


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
                gridfield();
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        // makes text safe inside '...' (an apostrophe in a note would break the query)
        string q(string value)
        {
            return value.Replace("'", "''");
        }


        // Only inquiries owned by the logged-in agent: assigned to them by the SiteAdmin,
        // or (when not assigned) for one of their properties
        void gridfield()
        {
            if (agentId == 0)
            {
                gvInquiries.DataSource = null;
                gvInquiries.DataBind();
                return;
            }

            getcon();

            string query =
                "SELECT i.InquiryID, i.FullName, i.Email, i.Phone, i.Property, i.Message, i.InquiryDate, i.Status, i.AgentNote, i.PropertyID, " +
                "d.DealID, d.Status AS DealStatus " +
                "FROM Inquiries i " +
                "LEFT JOIN Properties p ON p.PropertyID = i.PropertyID " +
                "OUTER APPLY (SELECT TOP 1 DealID, Status FROM Deals WHERE Deals.InquiryID = i.InquiryID ORDER BY DealID DESC) d " +
                "WHERE ISNULL(i.AssignedAgentID, p.AgentID) = '" + agentId + "'";

            // the status text comes from the dropdown's own items
            if (ddlStatusFilter.SelectedValue != "")
            {
                query += " AND i.Status = '" + q(ddlStatusFilter.SelectedValue) + "'";
            }

            query += " ORDER BY i.InquiryID DESC";

            da = new SqlDataAdapter(query, con);
            ds = new DataSet();
            da.Fill(ds);

            gvInquiries.DataSource = ds;
            gvInquiries.DataBind();

            con.Close();
        }


        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblMessage.Visible = false;
            gridfield();
        }


        protected void gvInquiries_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            // current status in the row's dropdown
            DropDownList ddl = (DropDownList)e.Row.FindControl("ddlRowStatus");
            string status = Convert.ToString(DataBinder.Eval(e.Row.DataItem, "Status"));

            ListItem item = ddl.Items.FindByValue(status);

            if (item != null)
            {
                ddl.ClearSelection();
                item.Selected = true;
            }

            // Close Deal button: shown once the status is Deal Done and there is no live deal yet
            HyperLink hl = (HyperLink)e.Row.FindControl("hlCloseDeal");
            Label lblDeal = (Label)e.Row.FindControl("lblDealInfo");

            bool dealDone = status == "Deal Done";
            bool hasProperty = DataBinder.Eval(e.Row.DataItem, "PropertyID") != DBNull.Value;
            object dealId = DataBinder.Eval(e.Row.DataItem, "DealID");
            string dealStatus = Convert.ToString(DataBinder.Eval(e.Row.DataItem, "DealStatus"));

            if (dealId != DBNull.Value && dealStatus != "Rejected")
            {
                lblDeal.Text = "Deal #" + dealId + ": " + Server.HtmlEncode(dealStatus);
                lblDeal.Visible = true;
            }
            else if (dealDone && hasProperty)
            {
                hl.NavigateUrl = "CloseDeal.aspx?InquiryID=" + DataBinder.Eval(e.Row.DataItem, "InquiryID");
                hl.Visible = true;

                if (dealId != DBNull.Value)
                {
                    lblDeal.Text = "Deal #" + dealId + " was rejected";
                    lblDeal.Visible = true;
                }
            }
            else if (dealDone)
            {
                lblDeal.Text = "Not linked to a property";
                lblDeal.Visible = true;
            }
        }


        protected void gvInquiries_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SaveRow") return;

            int inquiryId;

            if (!int.TryParse(Convert.ToString(e.CommandArgument), out inquiryId)) return;

            GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
            DropDownList ddl = (DropDownList)row.FindControl("ddlRowStatus");
            TextBox note = (TextBox)row.FindControl("txtRowNote");

            string text = note.Text.Trim();

            if (text.Length > 500) text = text.Substring(0, 500);

            string noteValue = text == "" ? "NULL" : "'" + q(text) + "'";

            getcon();

            // the agent can only change inquiries they own
            cmd = new SqlCommand(
                "UPDATE i SET i.Status = '" + q(ddl.SelectedValue) + "', i.AgentNote = " + noteValue + " " +
                "FROM Inquiries i LEFT JOIN Properties p ON p.PropertyID = i.PropertyID " +
                "WHERE i.InquiryID = '" + inquiryId + "' AND ISNULL(i.AssignedAgentID, p.AgentID) = '" + agentId + "'", con);

            int changed = cmd.ExecuteNonQuery();

            con.Close();

            lblMessage.Text = changed > 0 ? "Inquiry updated." : "This inquiry could not be updated.";
            lblMessage.Visible = true;

            gridfield();
        }


        // digits and + only, so the number works in a tel: link
        protected string TelHref(object phone)
        {
            return "tel:" + Regex.Replace(Convert.ToString(phone), @"[^\d+]", "");
        }
    }
}

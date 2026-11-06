using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Real_Estate.Admin
{
    public partial class ManageProperties : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        // the logged-in agent: an agent only sees and changes their own properties
        int agentId
        {
            get
            {
                int id;
                return int.TryParse(Convert.ToString(Session["AgentID"]), out id) ? id : 0;
            }
        }

        string fnm1;
        string fnm2;
        string fnm3;


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


        void ImgUpload()
        {
            string folder = "~/images/properties/";

            if (!Directory.Exists(Server.MapPath(folder)))
            {
                Directory.CreateDirectory(Server.MapPath(folder));
            }


            if (fuPhoto1.HasFile)
            {
                fnm1 = folder + DateTime.Now.Ticks.ToString() + "_" + Path.GetFileName(fuPhoto1.FileName);

                fuPhoto1.SaveAs(Server.MapPath(fnm1));
            }
            else
            {
                fnm1 = "";
            }


            if (fuPhoto2.HasFile)
            {
                fnm2 = folder + DateTime.Now.Ticks.ToString() + "_" + Path.GetFileName(fuPhoto2.FileName);

                fuPhoto2.SaveAs(Server.MapPath(fnm2));
            }
            else
            {
                fnm2 = "";
            }


            if (fuPhoto3.HasFile)
            {
                fnm3 = folder + DateTime.Now.Ticks.ToString() + "_" + Path.GetFileName(fuPhoto3.FileName);

                fuPhoto3.SaveAs(Server.MapPath(fnm3));
            }
            else
            {
                fnm3 = "";
            }
        }
        // The listing tab being shown. The values come from the "Listing For"
        // dropdown, so adding a listing type there adds a tab automatically.
        string currentListing()
        {
            string v = Convert.ToString(ViewState["Listing"]);

            if (ddlListingType.Items.FindByValue(v) == null)
            {
                v = ddlListingType.Items[0].Value;
            }

            return v;
        }


        protected bool IsActiveTab(object value)
        {
            return value.ToString() == currentListing();
        }


        void loadTabs()
        {
            getcon();

            da = new SqlDataAdapter("SELECT LOWER(LTRIM(RTRIM(ListingType))) AS ListingKey, COUNT(*) AS Total FROM Properties WHERE AgentID = '" + agentId + "' GROUP BY LOWER(LTRIM(RTRIM(ListingType)))", con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            DataTable tabs = new DataTable();
            tabs.Columns.Add("Value");
            tabs.Columns.Add("Text");
            tabs.Columns.Add("Total");

            foreach (ListItem item in ddlListingType.Items)
            {
                int total = 0;

                foreach (DataRow r in ds.Tables[0].Rows)
                {
                    if (r["ListingKey"].ToString() == item.Value.ToLower())
                    {
                        total = Convert.ToInt32(r["Total"]);
                    }
                }

                tabs.Rows.Add(item.Value, item.Text, total);
            }

            rptTabs.DataSource = tabs;
            rptTabs.DataBind();
        }


        protected void rptTabs_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Tab")
            {
                ViewState["Listing"] = e.CommandArgument.ToString();

                lblMessage.Text = "";
                lblMessage.Visible = false;

                gridfield();
            }
        }


        void gridfield()
        {
            getcon();

            da = new SqlDataAdapter("SELECT p.*, CASE WHEN LTRIM(RTRIM(p.Status)) = 'Available' THEN 1 ELSE 0 END AS IsOpen " +
                "FROM Properties p WHERE p.AgentID = '" + agentId + "' AND LOWER(LTRIM(RTRIM(p.ListingType))) = '" + currentListing().ToLower() + "' ORDER BY p.PropertyID DESC", con);

            ds = new DataSet();
            da.Fill(ds);

            // the tab already says Sale or Rent, so the Listing column is not needed
            gvProperties.Columns[4].Visible = false;

            gvProperties.DataSource = ds;
            gvProperties.DataBind();

            con.Close();

            loadTabs();
        }

        void clear()
        {
            txtTitle.Text = "";
            ddlType.SelectedIndex = 0;
            ddlListingType.SelectedIndex = 0;
            txtPrice.Text = "";
            txtLocation.Text = "";
            txtBedrooms.Text = "";
            txtBathrooms.Text = "";
            txtArea.Text = "";
            txtDescription.Text = "";
            btnSave.Text = "Save";
            ViewState["PropertyID"] = null;
            lblMessage.Text = "";
            lblMessage.Visible = false;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (btnSave.Text == "Save")
            {
                ImgUpload();

                getcon();

                string agentValue = agentId == 0 ? "NULL" : "'" + agentId + "'";

                cmd = new SqlCommand(
                    "INSERT INTO Properties " +
                    "(Title, PropertyType, ListingType, Price, Location, Bedrooms, Bathrooms, Area, Status, Description, Photo1, Photo2, Photo3, AgentID) " +
                    "VALUES('" +
                    txtTitle.Text + "','" +
                    ddlType.SelectedValue + "','" +
                    ddlListingType.SelectedValue + "','" +
                    txtPrice.Text + "','" +
                    txtLocation.Text + "','" +
                    txtBedrooms.Text + "','" +
                    txtBathrooms.Text + "','" +
                    txtArea.Text + "','Available','" +
                    txtDescription.Text + "','" +
                    fnm1 + "','" +
                    fnm2 + "','" +
                    fnm3 + "'," + agentValue + ")", con);

                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Property added successfully.";
                lblMessage.Visible = true;

                ViewState["Listing"] = ddlListingType.SelectedValue;

                clear();

                gridfield();
            }
            else
            {
                ImgUpload();

                getcon();

                string query = "UPDATE Properties SET " + "Title='" + txtTitle.Text + "'," + "PropertyType='" + ddlType.SelectedValue + "'," + "ListingType='" + ddlListingType.SelectedValue + "'," + "Price='" + txtPrice.Text + "'," + "Location='" + txtLocation.Text + "'," + "Bedrooms='" + txtBedrooms.Text + "'," + "Bathrooms='" + txtBathrooms.Text + "'," + "Area='" + txtArea.Text + "'," + "Description='" + txtDescription.Text + "'";

                if (fnm1 != "")
                {
                    query += ",Photo1='" + fnm1 + "'";
                }

                if (fnm2 != "")
                {
                    query += ",Photo2='" + fnm2 + "'";
                }

                if (fnm3 != "")
                {
                    query += ",Photo3='" + fnm3 + "'";
                }


                query += " WHERE PropertyID ='" + ViewState["PropertyID"] + "' AND AgentID = '" + agentId + "'";


                cmd = new SqlCommand(query, con);
                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Property updated successfully.";
                lblMessage.Visible = true;

                ViewState["Listing"] = ddlListingType.SelectedValue;

                clear();

                gridfield();
            }
        }

        protected void gvProperties_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                ViewState["PropertyID"] = e.CommandArgument.ToString();

                btnSave.Text = "Update";

                filldata();
            }

            else if (e.CommandName == "DeleteRow")
            {
                getcon();

                cmd = new SqlCommand("DELETE FROM Properties WHERE PropertyID='" + e.CommandArgument.ToString() + "' AND AgentID = '" + agentId + "'", con);
                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Property deleted successfully.";
                lblMessage.Visible = true;

                gridfield();
            }
        }

        void filldata()
        {
            getcon();

            cmd = new SqlCommand("SELECT * FROM Properties WHERE PropertyID='" + ViewState["PropertyID"] + "' AND AgentID = '" + agentId + "'", con);
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();

            da.Fill(ds);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                txtTitle.Text = ds.Tables[0].Rows[0]["Title"].ToString();
                ddlType.SelectedValue = ds.Tables[0].Rows[0]["PropertyType"].ToString();

                string lt = ds.Tables[0].Rows[0]["ListingType"].ToString().Trim();
                ddlListingType.SelectedIndex = lt.Equals("Rent", StringComparison.OrdinalIgnoreCase) ? 1 : 0;

                txtPrice.Text = ds.Tables[0].Rows[0]["Price"].ToString();
                txtLocation.Text = ds.Tables[0].Rows[0]["Location"].ToString();
                txtBedrooms.Text = ds.Tables[0].Rows[0]["Bedrooms"].ToString();
                txtBathrooms.Text = ds.Tables[0].Rows[0]["Bathrooms"].ToString();
                txtArea.Text = ds.Tables[0].Rows[0]["Area"].ToString();
                txtDescription.Text = ds.Tables[0].Rows[0]["Description"].ToString();
            }

            con.Close();
        }
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            clear();
        }

    }
}
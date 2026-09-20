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
        void gridfield()
        {
            getcon();

            da = new SqlDataAdapter("SELECT * FROM Properties ORDER BY PropertyID DESC", con);

            ds = new DataSet();
            da.Fill(ds);
            gvProperties.DataSource = ds;
            gvProperties.DataBind();

            con.Close();
        }

        void clear()
        {
            txtTitle.Text = "";
            ddlType.SelectedIndex = 0;
            txtPrice.Text = "";
            txtLocation.Text = "";
            txtBedrooms.Text = "";
            txtBathrooms.Text = "";
            txtArea.Text = "";
            txtStatus.Text = "";
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

                // the agent who is logged in becomes the owner of the new listing
                string agentId = Session["AgentID"] == null ? "NULL" : "'" + Session["AgentID"].ToString() + "'";

                cmd = new SqlCommand(
                    "INSERT INTO Properties " +
                    "(Title, PropertyType, Price, Location, Bedrooms, Bathrooms, Area, Status, Description, Photo1, Photo2, Photo3, AgentID) " +
                    "VALUES('" +
                    txtTitle.Text + "','" +
                    ddlType.SelectedValue + "','" +
                    txtPrice.Text + "','" +
                    txtLocation.Text + "','" +
                    txtBedrooms.Text + "','" +
                    txtBathrooms.Text + "','" +
                    txtArea.Text + "','" +
                    txtStatus.Text + "','" +
                    txtDescription.Text + "','" +
                    fnm1 + "','" +
                    fnm2 + "','" +
                    fnm3 + "'," + agentId + ")",con);

                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Property added successfully.";
                lblMessage.Visible = true;

                clear();

                gridfield();
            }
            else
            {
                ImgUpload();

                getcon();

                string query = "UPDATE Properties SET " + "Title='" + txtTitle.Text + "'," + "PropertyType='" + ddlType.SelectedValue + "'," + "Price='" + txtPrice.Text + "'," + "Location='" + txtLocation.Text + "'," + "Bedrooms='" + txtBedrooms.Text + "'," + "Bathrooms='" + txtBathrooms.Text + "'," + "Area='" + txtArea.Text + "'," + "Status='" + txtStatus.Text + "'," + "Description='" + txtDescription.Text + "'";
                 
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


                query += "WHERE PropertyID ='" + ViewState["PropertyID"] + "'";


                cmd = new SqlCommand(query, con);
                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Property updated successfully.";
                lblMessage.Visible = true;

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

                cmd = new SqlCommand("DELETE FROM Properties WHERE PropertyID='" + e.CommandArgument.ToString() + "'", con);
                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text ="Property deleted successfully.";
                lblMessage.Visible = true;

                gridfield();
            }
        }


        void filldata()
        {
            getcon();

            cmd = new SqlCommand("SELECT * FROM Properties WHERE PropertyID='" + ViewState["PropertyID"] + "'", con);
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();

            da.Fill(ds);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                txtTitle.Text = ds.Tables[0].Rows[0]["Title"].ToString();
                ddlType.SelectedValue = ds.Tables[0].Rows[0]["PropertyType"].ToString();
                txtPrice.Text = ds.Tables[0].Rows[0]["Price"].ToString();
                txtLocation.Text = ds.Tables[0].Rows[0]["Location"].ToString();
                txtBedrooms.Text = ds.Tables[0].Rows[0]["Bedrooms"].ToString();
                txtBathrooms.Text = ds.Tables[0].Rows[0]["Bathrooms"].ToString();
                txtArea.Text = ds.Tables[0].Rows[0]["Area"].ToString();
                txtStatus.Text = ds.Tables[0].Rows[0]["Status"].ToString();
                txtDescription.Text = ds.Tables[0].Rows[0]["Description"].ToString();
            }

            con.Close();
        }


        protected void btnCancel_Click(object sender,EventArgs e)
        {
            clear();
        }
    }
}
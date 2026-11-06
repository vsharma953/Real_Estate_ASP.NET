using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI.WebControls;

namespace Real_Estate.SiteAdmin
{
    public partial class ManageAgents : System.Web.UI.Page
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
                gridfield();
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        void gridfield()
        {
            getcon();

            da = new SqlDataAdapter("SELECT Agents.AgentID, Agents.FullName, Agents.Email, Agents.Phone, Agents.Status, Agents.CommissionPercent, (SELECT COUNT(*) FROM Properties WHERE Properties.AgentID = Agents.AgentID) AS Listings FROM Agents ORDER BY Agents.AgentID DESC", con);

            ds = new DataSet();
            da.Fill(ds);

            gvAgents.DataSource = ds;
            gvAgents.DataBind();

            con.Close();
        }


        void clear()
        {
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            txtPassword.Text = "";
            ddlStatus.SelectedIndex = 0;
            txtCommission.Text = "2";
            btnSave.Text = "Save";
            ViewState["AgentID"] = null;
            lblMessage.Text = "";
            lblMessage.Visible = false;
        }


        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (txtFullName.Text == "" || txtEmail.Text == "")
            {
                lblMessage.Text = "Full name and email are required.";
                lblMessage.Visible = true;
                return;
            }

            // commission is a percentage between 0 and 100
            decimal commission;

            if (!decimal.TryParse(txtCommission.Text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out commission) || commission < 0 || commission > 100)
            {
                lblMessage.Text = "Commission must be a number between 0 and 100.";
                lblMessage.Visible = true;
                return;
            }

            if (btnSave.Text == "Save")
            {
                if (txtPassword.Text == "")
                {
                    lblMessage.Text = "Password is required for a new agent.";
                    lblMessage.Visible = true;
                    return;
                }

                getcon();

                cmd = new SqlCommand("SELECT * FROM Agents WHERE Email = '" + txtEmail.Text + "'", con);
                da = new SqlDataAdapter(cmd);
                ds = new DataSet();
                da.Fill(ds);

                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    lblMessage.Text = "An agent with this email already exists.";
                    lblMessage.Visible = true;
                    con.Close();
                    return;
                }

                cmd = new SqlCommand("INSERT INTO Agents(FullName, Email, Phone, Password, Status, CommissionPercent) " +
                    "VALUES('" +
                    txtFullName.Text + "','" +
                    txtEmail.Text + "','" +
                    txtPhone.Text + "','" +
                    txtPassword.Text + "','" +
                    ddlStatus.SelectedValue + "','" +
                    commission.ToString(CultureInfo.InvariantCulture) + "')", con);

                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Agent added successfully.";
                lblMessage.Visible = true;

                clear();

                gridfield();
            }
            else
            {
                getcon();

                cmd = new SqlCommand("SELECT * FROM Agents WHERE Email = '" + txtEmail.Text + "' AND AgentID <> '" + ViewState["AgentID"] + "'", con);
                da = new SqlDataAdapter(cmd);
                ds = new DataSet();
                da.Fill(ds);

                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    lblMessage.Text = "Another agent already uses this email.";
                    lblMessage.Visible = true;
                    con.Close();
                    return;
                }

                string query = "UPDATE Agents SET " + "FullName='" + txtFullName.Text + "'," + "Email='" + txtEmail.Text + "'," + "Phone='" + txtPhone.Text + "'," + "Status='" + ddlStatus.SelectedValue + "'," + "CommissionPercent='" + commission.ToString(CultureInfo.InvariantCulture) + "'";

                if (txtPassword.Text != "")
                {
                    query += ",Password='" + txtPassword.Text + "'";
                }

                query += " WHERE AgentID='" + ViewState["AgentID"] + "'";

                cmd = new SqlCommand(query, con);
                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Agent updated successfully.";
                lblMessage.Visible = true;

                clear();

                gridfield();
            }
        }


        protected void gvAgents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                ViewState["AgentID"] = e.CommandArgument.ToString();

                btnSave.Text = "Update";

                filldata();
            }


            else if (e.CommandName == "DeleteRow")
            {
                getcon();

                cmd = new SqlCommand("UPDATE Properties SET AgentID=NULL WHERE AgentID='" + e.CommandArgument.ToString() + "'", con);
                cmd.ExecuteNonQuery();

                cmd = new SqlCommand("DELETE FROM Agents WHERE AgentID='" + e.CommandArgument.ToString() + "'", con);
                cmd.ExecuteNonQuery();

                con.Close();

                lblMessage.Text = "Agent deleted successfully. Their listings are now unassigned.";
                lblMessage.Visible = true;

                gridfield();
            }
        }

        void filldata()
        {
            getcon();

            cmd = new SqlCommand("SELECT * FROM Agents WHERE AgentID='" + ViewState["AgentID"] + "'", con);
            da = new SqlDataAdapter(cmd);
            ds = new DataSet();

            da.Fill(ds);

            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                txtFullName.Text = ds.Tables[0].Rows[0]["FullName"].ToString();
                txtEmail.Text = ds.Tables[0].Rows[0]["Email"].ToString();
                txtPhone.Text = ds.Tables[0].Rows[0]["Phone"].ToString();
                ddlStatus.SelectedValue = ds.Tables[0].Rows[0]["Status"].ToString();
                txtCommission.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["CommissionPercent"]).ToString("0.##", CultureInfo.InvariantCulture);
                txtPassword.Text = "";
            }

            con.Close();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            clear();
        }
    }
}
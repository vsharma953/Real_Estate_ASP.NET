using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI.WebControls;

namespace Real_Estate.SiteAdmin
{
    public partial class Settings : System.Web.UI.Page
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
                loadSettings();
                loadAgents();
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        string q(string value)
        {
            return value.Replace("'", "''");
        }


        void showMessage(string text, bool success)
        {
            lblMessage.Text = Server.HtmlEncode(text);
            lblMessage.CssClass = "message" + (success ? "" : " message-error");
            lblMessage.Visible = true;
        }


        string setting(string key)
        {
            cmd = new SqlCommand("SELECT SettingValue FROM Settings WHERE SettingKey = '" + q(key) + "'", con);
            object v = cmd.ExecuteScalar();

            return v == null ? "" : v.ToString();
        }


        // update the row, or add it when it does not exist yet
        void saveSetting(string key, string value)
        {
            cmd = new SqlCommand(
                "IF EXISTS (SELECT 1 FROM Settings WHERE SettingKey = '" + q(key) + "') " +
                "UPDATE Settings SET SettingValue = '" + q(value) + "' WHERE SettingKey = '" + q(key) + "' " +
                "ELSE INSERT INTO Settings (SettingKey, SettingValue) VALUES('" + q(key) + "','" + q(value) + "')", con);
            cmd.ExecuteNonQuery();
        }


        void loadSettings()
        {
            getcon();

            txtCurrency.Text = setting("CurrencySymbol");
            txtDefaultRate.Text = setting("DefaultCommissionPercent");

            con.Close();
        }


        void loadAgents()
        {
            getcon();

            da = new SqlDataAdapter("SELECT AgentID, FullName, Status, CommissionPercent FROM Agents ORDER BY FullName", con);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            gvAgents.DataSource = ds;
            gvAgents.DataBind();
        }


        // always written with a dot, so it is read back correctly on any computer
        protected string RateText(object value)
        {
            return value == null || value == DBNull.Value ? "" : Convert.ToDecimal(value).ToString("0.##", CultureInfo.InvariantCulture);
        }


        // a percentage between 0 and 100
        bool tryRate(string text, out decimal rate)
        {
            return decimal.TryParse(text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out rate) && rate >= 0 && rate <= 100;
        }


        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            string currency = txtCurrency.Text.Trim();
            decimal rate;

            if (!tryRate(txtDefaultRate.Text, out rate))
            {
                showMessage("The default commission must be a number between 0 and 100.", false);
                return;
            }

            getcon();

            saveSetting("CurrencySymbol", currency);
            saveSetting("DefaultCommissionPercent", rate.ToString(CultureInfo.InvariantCulture));

            con.Close();

            showMessage("Settings saved.", true);
        }


        protected void btnSaveRates_Click(object sender, EventArgs e)
        {
            // check every row first so nothing is half-saved
            foreach (GridViewRow row in gvAgents.Rows)
            {
                string text = ((TextBox)row.FindControl("txtAgentRate")).Text.Trim();
                decimal rate;

                if (text != "" && !tryRate(text, out rate))
                {
                    showMessage("Each agent's commission must be empty or a number between 0 and 100.", false);
                    return;
                }
            }

            getcon();

            foreach (GridViewRow row in gvAgents.Rows)
            {
                int agentId = Convert.ToInt32(gvAgents.DataKeys[row.RowIndex].Value);
                string text = ((TextBox)row.FindControl("txtAgentRate")).Text.Trim();
                decimal rate;

                string value = "NULL";

                if (text != "" && tryRate(text, out rate))
                {
                    value = rate.ToString(CultureInfo.InvariantCulture);
                }

                cmd = new SqlCommand("UPDATE Agents SET CommissionPercent = " + value + " WHERE AgentID = '" + agentId + "'", con);
                cmd.ExecuteNonQuery();
            }

            con.Close();

            showMessage("Agent commission rates saved.", true);
        }
    }
}

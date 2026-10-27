using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;

namespace Real_Estate
{
    public partial class EMICalculator : System.Web.UI.Page
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
                // starting values come from Web.config (appSettings) - NOT hardcoded in code
                txtRate.Text = ConfigurationManager.AppSettings["EMI:InterestRate"];
                txtTenure.Text = ConfigurationManager.AppSettings["EMI:TenureYears"];
                txtDownPayment.Text = ConfigurationManager.AppSettings["EMI:DownPaymentPercent"];

                loadProperties();

                // EMICalculator.aspx?PropertyID=5 (link from the Residences popup)
                string id = Convert.ToString(Request.QueryString["PropertyID"]);

                if (ddlProperty.Items.FindByValue(id) != null)
                {
                    ddlProperty.SelectedValue = id;
                    fillPrice();
                }
            }
        }


        void getcon()
        {
            con = new SqlConnection(s);
            con.Open();
        }


        // only properties that are still for sale can be financed
        void loadProperties()
        {
            getcon();

            // No user input here, so this static query is safe as-is
            da = new SqlDataAdapter("SELECT PropertyID, Title, Location, Price FROM Properties WHERE LOWER(LTRIM(RTRIM(ListingType))) = 'sale' AND LOWER(LTRIM(ISNULL(Status, ''))) <> 'sold' ORDER BY Title", con);

            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            ddlProperty.Items.Clear();
            ddlProperty.Items.Add(new ListItem("-- Enter a price manually --", "0"));

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                string text = row["Title"].ToString();

                if (row["Location"].ToString().Trim() != "")
                {
                    text += " - " + row["Location"].ToString();
                }

                decimal price = parsePrice(row["Price"].ToString());

                if (price > 0)
                {
                    text += " ($" + price.ToString("N0", CultureInfo.InvariantCulture) + ")";
                }

                ddlProperty.Items.Add(new ListItem(text, row["PropertyID"].ToString()));
            }
        }


        // same cleaning rule the Residences page uses for its prices
        decimal parsePrice(string raw)
        {
            string cleaned = Regex.Replace(raw, @"[^\d.,]", "");

            Match m = Regex.Match(cleaned, @"^(.*)[.,](\d{1,2})$");

            if (m.Success)
            {
                cleaned = m.Groups[1].Value;
            }

            string digits = Regex.Replace(cleaned, @"\D", "");

            decimal value;

            if (digits.Length == 0 || !decimal.TryParse(digits, NumberStyles.None, CultureInfo.InvariantCulture, out value))
            {
                return 0;
            }

            return value;
        }


        void fillPrice()
        {
            if (ddlProperty.SelectedValue == "0")
            {
                return;
            }

            // Validate the dropdown value is actually a number before it
            // ever touches a query - a crafted POST could put anything here.
            int propertyId;

            if (!int.TryParse(ddlProperty.SelectedValue, out propertyId))
            {
                return;
            }

            getcon();

            // Parameterized query: the value is passed as data, never
            // concatenated into the SQL text, so it can't be used to
            // inject extra SQL regardless of what the client sends.
            cmd = new SqlCommand("SELECT Price FROM Properties WHERE PropertyID = '"+propertyId+"'", con);
            cmd.Parameters.Add("propertyId", SqlDbType.Int).Value = propertyId;

            da = new SqlDataAdapter(cmd);
            ds = new DataSet();
            da.Fill(ds);

            con.Close();

            if (ds.Tables[0].Rows.Count > 0)
            {
                decimal price = parsePrice(ds.Tables[0].Rows[0]["Price"].ToString());

                txtPrice.Text = price > 0 ? price.ToString("0", CultureInfo.InvariantCulture) : "";
            }
        }


        void showError(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;

            pnlResult.Visible = false;
            pnlEmpty.Visible = true;
        }


        protected void ddlProperty_SelectedIndexChanged(object sender, EventArgs e)
        {
            fillPrice();

            lblMessage.Visible = false;
            pnlResult.Visible = false;
            pnlEmpty.Visible = true;
        }


        protected void btnCalculate_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = false;

            decimal price, down, rate, years;

            if (!decimal.TryParse(txtPrice.Text.Replace(",", "").Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out price) || price <= 0)
            {
                showError("Please enter a valid property price.");
                return;
            }

            if (!decimal.TryParse(txtDownPayment.Text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out down) || down < 0 || down >= 100)
            {
                showError("Down payment must be a percentage from 0 to less than 100.");
                return;
            }

            if (!decimal.TryParse(txtRate.Text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out rate) || rate <= 0 || rate > 100)
            {
                showError("Please enter a valid yearly interest rate.");
                return;
            }

            if (!decimal.TryParse(txtTenure.Text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out years) || years < 1 || years > 50 || years != Math.Floor(years))
            {
                showError("Tenure must be a whole number of years (1 to 50).");
                return;
            }

            double loan = (double)(price - (price * down / 100));
            double r = (double)rate / 12 / 100;
            int months = (int)years * 12;

            double growth = Math.Pow(1 + r, months);
            double emi = loan * r * growth / (growth - 1);

            double totalPayment = emi * months;

            litLoan.Text = money(loan);
            litEmi.Text = money(emi);
            litInterest.Text = money(totalPayment - loan);
            litTotal.Text = money(totalPayment);

            // year by year breakdown
            DataTable dt = new DataTable();
            dt.Columns.Add("Year");
            dt.Columns.Add("Principal");
            dt.Columns.Add("Interest");
            dt.Columns.Add("Balance");

            double balance = loan;
            double yearPrincipal = 0;
            double yearInterest = 0;

            for (int m = 1; m <= months; m++)
            {
                double interest = balance * r;
                double principal = emi - interest;

                balance -= principal;
                yearPrincipal += principal;
                yearInterest += interest;

                if (m % 12 == 0)
                {
                    dt.Rows.Add(m / 12, money(yearPrincipal), money(yearInterest), money(Math.Max(balance, 0)));

                    yearPrincipal = 0;
                    yearInterest = 0;
                }
            }

            gvSchedule.DataSource = dt;
            gvSchedule.DataBind();

            pnlEmpty.Visible = false;
            pnlResult.Visible = true;
        }


        string money(double value)
        {
            return "$" + value.ToString("N0", CultureInfo.InvariantCulture);
        }
    }
}
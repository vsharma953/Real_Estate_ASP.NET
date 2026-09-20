using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

namespace Real_Estate
{
    public partial class Properties : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter da;
        DataSet ds;

        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        // tiny grey placeholder used when a property has no photo at all
        const string NoPhoto = "data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 width=%27800%27 height=%27520%27%3E%3Crect width=%27100%25%27 height=%27100%25%27 fill=%27%23d9d4cb%27/%3E%3C/svg%3E";


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState["Filter"] = "all";
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
            string filter = Convert.ToString(ViewState["Filter"]);

            getcon();

            if (filter == "villa" || filter == "penthouse" || filter == "townhouse")
            {
                cmd = new SqlCommand("SELECT * FROM Properties WHERE LOWER(LTRIM(RTRIM(PropertyType))) = '" + filter + "' ORDER BY PropertyID DESC", con);
                da = new SqlDataAdapter(cmd);
            }
            else
            {
                filter = "all";
                da = new SqlDataAdapter("SELECT * FROM Properties ORDER BY PropertyID DESC", con);
            }

            ds = new DataSet();
            da.Fill(ds);

            dlProperties.DataSource = ds;
            dlProperties.DataBind();

            con.Close();

            bool hasRows = ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0;

            pnlEmpty.Visible = !hasRows;

            if (!hasRows)
            {
                if (filter == "all")
                {
                    lblEmpty.Text = "No residences have been listed yet. Please check back soon.";
                }
                else
                {
                    lblEmpty.Text = "No " + filter + "s are listed right now. Please check back soon.";
                }
            }

            markActive(filter);
        }


        void markActive(string filter)
        {
            lnkAll.CssClass = "filter-btn" + (filter == "all" ? " active" : "");
            lnkVilla.CssClass = "filter-btn" + (filter == "villa" ? " active" : "");
            lnkPenthouse.CssClass = "filter-btn" + (filter == "penthouse" ? " active" : "");
            lnkTownhouse.CssClass = "filter-btn" + (filter == "townhouse" ? " active" : "");
        }


        protected void Filter_Command(object sender, CommandEventArgs e)
        {
            string f = Convert.ToString(e.CommandArgument).ToLower();

            if (f != "villa" && f != "penthouse" && f != "townhouse")
            {
                f = "all";
            }

            ViewState["Filter"] = f;

            gridfield();
        }


        // ---------- helpers used by the DataList ItemTemplate ----------

        protected string Photo(object value)
        {
            string p = Convert.ToString(value).Trim();

            if (p.Length == 0)
            {
                return "";
            }

            return ResolveUrl(p);
        }


        protected string MainPhoto(object p1, object p2, object p3)
        {
            foreach (object o in new object[] { p1, p2, p3 })
            {
                string u = Photo(o);

                if (u.Length > 0)
                {
                    return u;
                }
            }

            return NoPhoto;
        }


        protected int PhotoCount(object p1, object p2, object p3)
        {
            int count = 0;

            foreach (object o in new object[] { p1, p2, p3 })
            {
                if (Photo(o).Length > 0)
                {
                    count++;
                }
            }

            return count;
        }


        protected string Thumbs(object p1, object p2, object p3)
        {
            StringBuilder sb = new StringBuilder();
            bool first = true;

            foreach (object o in new object[] { p1, p2, p3 })
            {
                string u = Photo(o);

                if (u.Length == 0)
                {
                    continue;
                }

                sb.Append("<img src=\"" + HttpUtility.HtmlAttributeEncode(u) + "\" class=\"thumb-preview" + (first ? " active" : "") + "\" alt=\"Gallery photo\" loading=\"lazy\" />");

                first = false;
            }

            return sb.ToString();
        }


        protected string TypeLabel(object type, object status)
        {
            string t = Convert.ToString(type).Trim();

            if (t.Length == 0)
            {
                t = "Residence";
            }
            else
            {
                t = char.ToUpper(t[0]) + t.Substring(1).ToLower();
            }

            string st = Convert.ToString(status).Trim();

            if (st.Equals("sold", StringComparison.OrdinalIgnoreCase))
            {
                t += " \u00B7 Sold";
            }

            return t;
        }


        // Price is saved as free text by the admin form ("282000", "$ 2.800.000", "1,950,000" ...)
        // so it is normalised to one style here: $2,800,000
        protected string FormatPrice(object price)
        {
            string raw = Convert.ToString(price).Trim();

            if (raw.Length == 0)
            {
                return "Price on request";
            }

            string cleaned = Regex.Replace(raw, @"[^\d.,]", "");

            // drop a decimal part such as ".50" (1 or 2 digits after the last separator)
            Match m = Regex.Match(cleaned, @"^(.*)[.,](\d{1,2})$");

            if (m.Success)
            {
                cleaned = m.Groups[1].Value;
            }

            string digits = Regex.Replace(cleaned, @"\D", "");

            decimal value;

            if (digits.Length == 0 || !decimal.TryParse(digits, NumberStyles.None, CultureInfo.InvariantCulture, out value))
            {
                return raw;
            }

            return "$" + value.ToString("N0", CultureInfo.InvariantCulture);
        }


        protected string FormatArea(object area)
        {
            string a = Convert.ToString(area).Trim();

            if (a.Length == 0)
            {
                return "";
            }

            decimal n;

            if (decimal.TryParse(a.Replace(",", ""), NumberStyles.Number, CultureInfo.InvariantCulture, out n))
            {
                return n.ToString("N0", CultureInfo.InvariantCulture) + " sq ft";
            }

            return a;
        }
    }
}

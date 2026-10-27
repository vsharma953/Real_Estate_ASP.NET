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

                string l = (Request.QueryString["Listing"] ?? "").ToLower();

                ViewState["Listing"] = (l == "sale" || l == "rent") ? l : "all";

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
            string listing = Convert.ToString(ViewState["Listing"]);

            if (filter != "villa" && filter != "penthouse" && filter != "townhouse")
            {
                filter = "all";
            }

            if (listing != "sale" && listing != "rent")
            {
                listing = "all";
            }

            string clause = "";

            if (filter != "all")
            {
                clause = "LOWER(LTRIM(RTRIM(PropertyType))) = '" + filter + "'";
            }

            if (listing != "all")
            {
                clause += (clause == "" ? "" : " AND ") + "LOWER(LTRIM(RTRIM(ListingType))) = '" + listing + "'";
            }

            getcon();

            if (clause != "")
            {
                cmd = new SqlCommand("SELECT * FROM Properties WHERE " + clause + " ORDER BY PropertyID DESC", con);
                da = new SqlDataAdapter(cmd);
            }
            else
            {
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
                string what = filter == "all" ? "residences" : filter + "s";
                string forWhat = listing == "sale" ? " for sale" : (listing == "rent" ? " for rent" : "");

                if (filter == "all" && listing == "all")
                {
                    lblEmpty.Text = "No residences have been listed yet. Please check back soon.";
                }
                else
                {
                    lblEmpty.Text = "No " + what + forWhat + " are listed right now. Please check back soon.";
                }
            }

            markActive(filter, listing);
        }


        void markActive(string filter, string listing)
        {
            lnkAll.CssClass = "filter-btn" + (filter == "all" ? " active" : "");
            lnkVilla.CssClass = "filter-btn" + (filter == "villa" ? " active" : "");
            lnkPenthouse.CssClass = "filter-btn" + (filter == "penthouse" ? " active" : "");
            lnkTownhouse.CssClass = "filter-btn" + (filter == "townhouse" ? " active" : "");

            lnkListAll.CssClass = "filter-btn" + (listing == "all" ? " active" : "");
            lnkForSale.CssClass = "filter-btn" + (listing == "sale" ? " active" : "");
            lnkForRent.CssClass = "filter-btn" + (listing == "rent" ? " active" : "");
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

        protected void Listing_Command(object sender, CommandEventArgs e)
        {
            string l = Convert.ToString(e.CommandArgument).ToLower();

            if (l != "sale" && l != "rent")
            {
                l = "all";
            }

            ViewState["Listing"] = l;

            gridfield();
        }

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

        protected string ListingKey(object listing)
        {
            string l = Convert.ToString(listing).Trim();

            return l.Equals("Rent", StringComparison.OrdinalIgnoreCase) ? "rent" : "sale";
        }

        protected string TypeLabel(object type, object status, object listing)
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
            else
            {
                t += ListingKey(listing) == "rent" ? " \u00B7 For Rent" : " \u00B7 For Sale";
            }

            return t;
        }

        // price for display - rentals are shown per month
        protected string PriceLabel(object price, object listing)
        {
            string p = FormatPrice(price);

            if (ListingKey(listing) == "rent" && !p.Contains("/ month") && !p.Equals("Price on request"))
            {
                p += " / month";
            }

            return p;
        }

        protected string FormatPrice(object price)
        {
            string raw = Convert.ToString(price).Trim();

            if (raw.Length == 0)
            {
                return "Price on request";
            }
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

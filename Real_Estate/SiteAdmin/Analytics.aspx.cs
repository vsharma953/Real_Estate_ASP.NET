using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;

namespace Real_Estate.SiteAdmin
{
    public partial class Analytics : System.Web.UI.Page
    {
        string s = ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString;

        // JSON used by Chart.js in Analytics.aspx
        protected string MonthlyJson = "{\"labels\":[],\"data\":[]}";
        protected string StatusJson = "{\"labels\":[],\"closed\":[],\"pending\":[]}";
        protected string AgentJson = "{\"names\":[],\"listings\":[],\"closed\":[],\"pending\":[],\"revenue\":[]}";


        protected void Page_Load(object sender, EventArgs e)
        {
            loadReport();
        }


        DataTable fetch(string query)
        {
            using (SqlConnection con = new SqlConnection(s))
            using (SqlDataAdapter da = new SqlDataAdapter(query, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }


        // Same price cleaning logic as Dashboard
        static decimal parsePrice(object value)
        {
            if (value == null || value == DBNull.Value) return 0;

            string price = Regex.Replace(value.ToString(), @"[.,]\d{1,2}$", "");
            price = Regex.Replace(price, @"\D", "");

            decimal result;
            return decimal.TryParse(price, out result) ? result : 0;
        }


        static string norm(object value)
        {
            return value == null || value == DBNull.Value ? "" : value.ToString().Trim().ToLower();
        }


        static string toJson(object o)
        {
            // "<" escape so agent names can never break out of the <script> block
            return new JavaScriptSerializer().Serialize(o).Replace("<", "\\u003c");
        }


        static DataColumn findColumn(DataTable dt, string name)
        {
            foreach (DataColumn c in dt.Columns)
            {
                if (c.ColumnName.Equals(name, StringComparison.OrdinalIgnoreCase)) return c;
            }
            return null;
        }


        void loadReport()
        {
            DataTable agents = fetch("SELECT AgentID, FullName FROM Agents ORDER BY FullName");
            DataTable props = fetch("SELECT PropertyID, AgentID, ListingType, Price, Status FROM Properties");
            DataTable inq = fetch("SELECT * FROM Inquiries");

            // ---------- 1. Monthly inquiries (last 12 months) ----------
            DateTime now = DateTime.Now;
            DateTime start = new DateTime(now.Year, now.Month, 1).AddMonths(-11);

            List<string> labels = new List<string>();
            int[] counts = new int[12];

            for (int i = 0; i < 12; i++)
            {
                labels.Add(start.AddMonths(i).ToString("MMM yyyy"));
            }

            // The date column of Inquiries is auto-detected (first DateTime column,
            // preferring names containing "date" or "created")
            DataColumn dateCol = null;
            foreach (DataColumn c in inq.Columns)
            {
                if (c.DataType == typeof(DateTime))
                {
                    if (dateCol == null) dateCol = c;
                    string n = c.ColumnName.ToLower();
                    if (n.Contains("date") || n.Contains("created")) { dateCol = c; break; }
                }
            }

            int thisMonth = 0;

            if (dateCol != null)
            {
                foreach (DataRow r in inq.Rows)
                {
                    if (r[dateCol] == DBNull.Value) continue;

                    DateTime d = (DateTime)r[dateCol];
                    int idx = (d.Year - start.Year) * 12 + d.Month - start.Month;

                    if (idx >= 0 && idx < 12) counts[idx]++;
                    if (d.Year == now.Year && d.Month == now.Month) thisMonth++;
                }
            }
            else
            {
                lblNote.Text = "There is no Inquires.";
                lblNote.Visible = true;
            }

            MonthlyJson = toJson(new { labels = labels, data = counts });

            // ---------- 2. Sales / Rentals: closed vs pending ----------
            int saleClosed = 0, salePending = 0, rentClosed = 0, rentPending = 0;
            decimal soldRevenue = 0;

            foreach (DataRow r in props.Rows)
            {
                string listing = norm(r["ListingType"]);
                string status = norm(r["Status"]);
                bool closed = status == "sold" || status == "rented" || status == "leased";

                if (listing == "sale")
                {
                    if (closed) { saleClosed++; soldRevenue += parsePrice(r["Price"]); }
                    else salePending++;
                }
                else if (listing == "rent")
                {
                    if (closed) rentClosed++;
                    else rentPending++;
                }
            }

            StatusJson = toJson(new
            {
                labels = new[] { "For Sale", "For Rent" },
                closed = new[] { saleClosed, rentClosed },
                pending = new[] { salePending, rentPending }
            });

            // ---------- 3. Agent performance ----------
            // Inquiries per agent: only possible if Inquiries has a PropertyID column
            DataColumn inqPropCol = findColumn(inq, "PropertyID");
            Dictionary<string, string> propToAgent = new Dictionary<string, string>();

            foreach (DataRow r in props.Rows)
            {
                if (r["AgentID"] != DBNull.Value)
                    propToAgent[r["PropertyID"].ToString()] = r["AgentID"].ToString();
            }

            Dictionary<string, int> inqByAgent = new Dictionary<string, int>();

            if (inqPropCol != null)
            {
                foreach (DataRow r in inq.Rows)
                {
                    if (r[inqPropCol] == DBNull.Value) continue;

                    string agentId;
                    if (propToAgent.TryGetValue(r[inqPropCol].ToString(), out agentId))
                    {
                        int c;
                        inqByAgent.TryGetValue(agentId, out c);
                        inqByAgent[agentId] = c + 1;
                    }
                }
            }

            List<string> names = new List<string>();
            List<int> listings = new List<int>();
            List<int> closedList = new List<int>();
            List<int> pendingList = new List<int>();
            List<decimal> revenueList = new List<decimal>();

            DataTable perf = new DataTable();
            perf.Columns.Add("Agent");
            perf.Columns.Add("Listings");
            perf.Columns.Add("Closed");
            perf.Columns.Add("Pending");
            perf.Columns.Add("Inquiries");
            perf.Columns.Add("Rate");
            perf.Columns.Add("Revenue");

            foreach (DataRow a in agents.Rows)
            {
                string id = a["AgentID"].ToString();
                int total = 0, closed = 0, pending = 0;
                decimal revenue = 0;

                foreach (DataRow r in props.Rows)
                {
                    if (r["AgentID"] == DBNull.Value || r["AgentID"].ToString() != id) continue;

                    total++;
                    string status = norm(r["Status"]);
                    bool isClosed = status == "sold" || status == "rented" || status == "leased";

                    if (isClosed)
                    {
                        closed++;
                        if (norm(r["ListingType"]) == "sale") revenue += parsePrice(r["Price"]);
                    }
                    else pending++;
                }

                int inqCount;
                inqByAgent.TryGetValue(id, out inqCount);
                double rate = total == 0 ? 0 : (closed * 100.0 / total);

                names.Add(a["FullName"].ToString());
                listings.Add(total);
                closedList.Add(closed);
                pendingList.Add(pending);
                revenueList.Add(revenue);

                perf.Rows.Add(
                    a["FullName"].ToString(),
                    total,
                    closed,
                    pending,
                    inqPropCol != null ? inqCount.ToString() : "-",
                    rate.ToString("0.#") + "%",
                    "$" + revenue.ToString("N0"));
            }

            AgentJson = toJson(new
            {
                names = names,
                listings = listings,
                closed = closedList,
                pending = pendingList,
                revenue = revenueList
            });

            gvAgentPerf.DataSource = perf;
            gvAgentPerf.DataBind();

            // ---------- KPI cards ----------
            int totalProps = props.Rows.Count;
            int totalClosed = saleClosed + rentClosed;

            litTotalInquiries.Text = inq.Rows.Count.ToString();
            litThisMonth.Text = thisMonth.ToString();
            litSoldRevenue.Text = "$" + soldRevenue.ToString("N0");
            litPendingSale.Text = salePending.ToString();
            litPendingRent.Text = rentPending.ToString();
            litConversion.Text = (totalProps == 0 ? 0 : totalClosed * 100.0 / totalProps).ToString("0.#") + "%";
        }
    }
}

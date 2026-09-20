using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Real_Estate.Admin
{
    public partial class Dashboard : System.Web.UI.Page
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

            da = new SqlDataAdapter("SELECT * FROM Inquiries ORDER BY InquiryID DESC",con);

            ds = new DataSet();
            da.Fill(ds);

            gvRecentInquiries.DataSource = ds;
            gvRecentInquiries.DataBind();

            con.Close();
        }
    }
}
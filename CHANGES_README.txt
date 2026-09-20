Real_Estate — Exactly as submitted + SiteAdmin frontend
==========================================================

This build is your original project, completely untouched, plus one new
addition: a /SiteAdmin folder (the third panel - the actual site
administrator, who adds agents and can see their work).

Every file outside of /SiteAdmin is byte-for-byte identical to what you
uploaded - /Admin (the Agent Desk) was NOT touched, deleted, or renamed.
Only Real_Estate.csproj changed, and only to list the new SiteAdmin files
so Visual Studio picks them up.

THE THREE PANELS
------------------
1. Main site (public) - unchanged.
2. /Admin - the Agent Desk - unchanged, exactly as you submitted it.
3. /SiteAdmin - NEW, frontend only (see below).

WHAT "FRONTEND ONLY" MEANS HERE
-----------------------------------
/SiteAdmin has 4 real, working pages - Login, Dashboard, Manage Agents,
and Agent Work - built with the same look and structure as /Admin. You
can log in, click around, add/edit/delete agents, and browse listings by
agent, and it will feel like it's really working.

It isn't touching your database, though. The data lives in Session for
this build (sample agents and sample properties), so:
  - Add/Edit/Delete on Manage Agents and Agent Work all work, live, while
    you're using the site
  - none of it is saved anywhere permanent - it resets the moment your
    session ends or you restart the app

This is meant to let you see and try the design and the 3-panel flow
before wiring it to real data. The second zip (fully working) is the
exact same pages, reconnected to your actual database (Agents table,
Properties.AgentID, etc.) with the same GridView/database pattern used
throughout the rest of the project.

LOGIN
------
Site Admin (/SiteAdmin/Login.aspx):
    Email:    siteadmin@realestate.luxury
    Password: siteadmin123

Agent Desk (/Admin/Login.aspx) is unchanged - same login you already had.

RUNNING THE PROJECT
---------------------
Open Real_Estate.sln in Visual Studio (2019+), let NuGet restore, set
Real_Estate as the startup project, and run (IIS Express). No database
setup is required to preview /SiteAdmin in this build - the rest of the
site still needs Real_Estate_DB.mdf / SQL Server LocalDB as before.


==========================================================
RESIDENCES PAGE FIX (Properties.aspx)
==========================================================
Problem : "Type 'System.Web.UI.WebControls.DataList' does not have a public
          property named 'emptydatatemplate'". DataList has no
          EmptyDataTemplate (only GridView / ListView / FormView do).

Fix     : Properties.aspx, Properties.aspx.cs, Properties.aspx.designer.cs
          - asp:DataList (ItemTemplate) renders the property cards
          - same data pattern as the rest of the project:
            getcon() + SqlConnection + SqlDataAdapter + DataSet,
            connection string "DBConnection" from Web.config
          - Villas / Penthouses / Townhouses buttons filter by
            Properties.PropertyType (server side, DataList is rebound)
          - "no residences" message is a Label/Panel (replaces EmptyDataTemplate)
          - card click / "Explore Residence" opens the photo modal
          No other file was changed.


==========================================================
SITEADMIN CONNECTED TO THE DATABASE
==========================================================
SiteAdmin no longer uses Session/sample data. Every page uses the same
pattern as the rest of the project: getcon() + SqlConnection + SqlDataAdapter
+ DataSet -> GridView, connection string "DBConnection" from Web.config,
plain string queries (no @ parameters).

SiteAdmin/Login        -> checks the SiteAdmins table
SiteAdmin/Dashboard    -> live counts (Agents, Active Agents, Properties,
                          Inquiries) + NEW "Total Sell Amount" (sum of the
                          Price of every property whose Status is Sold)
SiteAdmin/ManageAgents -> add / update / delete rows in the Agents table
SiteAdmin/AgentWork    -> Properties joined to Agents, filter by agent,
                          delete a listing

New database objects (created automatically by Global.asax.cs on first run,
see Databases/SiteAdmin_Tables.sql for reference):
    Agents table, SiteAdmins table, Properties.AgentID column
    First logins are the same as before:
        Site Admin  siteadmin@realestate.luxury / siteadmin123
        Agent Desk  admin@realestate.luxury     / admin123  (agent "Julian Vance")
    Properties that already existed are assigned to that first agent.

Small changes needed so the three panels work together:
    Admin/Login.aspx(.cs)          -> agents log in from the Agents table
                                      (Inactive agents are refused); email
                                      pattern now accepts dots (sarah.w@...)
    Admin/ManageProperties.aspx.cs -> new listings store the logged-in AgentID
    Admin/Admin.Master(.cs)        -> shows the logged-in agent's name
    Real_Estate.csproj             -> lists Global.asax / Global.asax.cs


==========================================================
QUERY STYLE - SAME AS THE REST OF THE PROJECT
==========================================================
SiteAdmin/Login, Dashboard, ManageAgents, AgentWork and Admin/Login now use
only the plain style from LoginRegister / ManageProperties:
    cmd = new SqlCommand("SELECT * FROM Agents WHERE Email = '" + txtEmail.Text + "'", con);
    da = new SqlDataAdapter(cmd); ds = new DataSet(); da.Fill(ds);
No helper methods, no table aliases (p. / a.), no parameters.
The Residences filter (Properties.aspx.cs) uses the same style too.
Databases/SiteAdmin_Tables.sql = Agents table (+ SiteAdmins table and
Properties.AgentID column) - safe to run more than once.

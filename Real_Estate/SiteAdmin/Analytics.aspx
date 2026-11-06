

<%@ Page Title="Analytics" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="Real_Estate.SiteAdmin.Analytics" %>

<%@ Register assembly="CrystalDecisions.Web, Version=13.0.4000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div id="reportArea">

        <div class="report-head">
            <div>
                <h2 class="report-title">Analytics Report</h2>
                <p class="report-subtitle">Monthly inquiries, sales &amp; rental status and agent performance.</p>
                <p class="print-date" id="printDate"></p>
            </div>
            <button type="button" class="print-button" onclick="window.print();">Print / Save as PDF</button>
        </div>

        <asp:Label ID="lblNote" runat="server" Visible="false" CssClass="message"></asp:Label>

        <div class="metrics-row">
            <div class="metric-card">
                <p class="metric-title">Total Inquiries</p>
                <p class="metric-value"><asp:Literal ID="litTotalInquiries" runat="server" Text="0"></asp:Literal></p>
            </div>
            <div class="metric-card">
                <p class="metric-title">Inquiries This Month</p>
                <p class="metric-value"><asp:Literal ID="litThisMonth" runat="server" Text="0"></asp:Literal></p>
            </div>
            <div class="metric-card">
                <p class="metric-title">Sold Revenue</p>
                <p class="metric-value"><asp:Literal ID="litSoldRevenue" runat="server" Text="$0"></asp:Literal></p>
            </div>
            <div class="metric-card">
                <p class="metric-title">Pending Sales</p>
                <p class="metric-value"><asp:Literal ID="litPendingSale" runat="server" Text="0"></asp:Literal></p>
            </div>
            <div class="metric-card">
                <p class="metric-title">Pending Rentals</p>
                <p class="metric-value"><asp:Literal ID="litPendingRent" runat="server" Text="0"></asp:Literal></p>
            </div>
            <div class="metric-card">
                <p class="metric-title">Closing Rate</p>
                <p class="metric-value"><asp:Literal ID="litConversion" runat="server" Text="0%"></asp:Literal></p>
            </div>
        </div>

        <div class="chart-row">
            <div class="chart-card wide">
                <h3 class="chart-title">Monthly Inquiries</h3>
                <p class="chart-sub">Last 12 months</p>
                <div class="chart-box"><canvas id="chMonthly"></canvas></div>
            </div>
            <div class="chart-card">
                <h3 class="chart-title">Sales &amp; Rentals Status</h3>
                <p class="chart-sub">Closed vs pending listings</p>
                <div class="chart-box"><canvas id="chStatus"></canvas></div>
            </div>
        </div>

        <div class="chart-row">
            <div class="chart-card wide">
                <h3 class="chart-title">Agent Performance</h3>
                <p class="chart-sub">Listings, closed deals and pending per agent</p>
                <div class="chart-box"><canvas id="chAgents"></canvas></div>
            </div>
            <div class="chart-card">
                <h3 class="chart-title">Revenue by Agent</h3>
                <p class="chart-sub">Total value of sold properties</p>
                <div class="chart-box"><canvas id="chRevenue"></canvas></div>
            </div>
        </div>

        <div class="chart-card full">
            <h3 class="chart-title">Agent Scorecard</h3>
            <p class="chart-sub">Detailed breakdown per agent</p>
            <div class="table-scroll">
                <div class="table-scroll">
<asp:GridView ID="gvAgentPerf" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="perf-grid" EmptyDataText="No agents found.">
                    <Columns>
                        <asp:BoundField DataField="Agent" HeaderText="Agent" />
                        <asp:BoundField DataField="Listings" HeaderText="Listings" />
                        <asp:BoundField DataField="Closed" HeaderText="Closed" />
                        <asp:BoundField DataField="Pending" HeaderText="Pending" />
                        <asp:BoundField DataField="Inquiries" HeaderText="Inquiries" />
                        <asp:BoundField DataField="Rate" HeaderText="Closing Rate" />
                        <asp:BoundField DataField="Revenue" HeaderText="Sold Revenue" />
                    </Columns>
                </asp:GridView>
</div>
            </div>
        </div>

    </div> <!-- /reportArea -->
        <div class="print-hide" style="background:#fff; border:1px solid #e5e5e5; border-radius:6px; padding:20px; margin-top:20px;">
        <h3 style="margin:0 0 12px 0;">Reports</h3>
        <asp:DropDownList ID="ddlReport" runat="server" style="padding:9px 12px; min-width:260px; margin-right:10px;">
            <asp:ListItem Value="" Text="-- Select a report --"></asp:ListItem>
            <asp:ListItem Value="sales" Text="Sales Report"></asp:ListItem>
            <asp:ListItem Value="rental" Text="Rental Report"></asp:ListItem>
            <asp:ListItem Value="agent" Text="Agent Performance"></asp:ListItem>
            <asp:ListItem Value="commission" Text="Commission Statement"></asp:ListItem>
            <asp:ListItem Value="inquiry" Text="Inquiry Report"></asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report" CssClass="print-button" OnClick="btnGenerateReport_Click" />
        <asp:Label ID="lblReportMsg" runat="server" Visible="false" ForeColor="#b00020" style="margin-left:10px;"></asp:Label>
            <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" AutoDataBind="true" />
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
    <script>
        var monthly = <%= MonthlyJson %>;
        var statusData = <%= StatusJson %>;
        var agents     = <%= AgentJson %>;

        var GOLD = '#9c7f50', DARK = '#222222', GREEN = '#4f8a5b';

        Chart.defaults.font.family = "'Inter', system-ui, sans-serif";
        Chart.defaults.font.size = 12;
        Chart.defaults.color = '#62625e';
        Chart.defaults.animation = false;

        document.getElementById('printDate').textContent =
            'Generated on ' + new Date().toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });

        function resizeCharts() {
            Object.values(Chart.instances).forEach(function (c) { c.resize(); });
        }
        window.addEventListener('beforeprint', resizeCharts);
        window.addEventListener('afterprint', resizeCharts);

        var baseOpts = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom', labels: { boxWidth: 12 } } },
            scales: {
                y: { beginAtZero: true, ticks: { precision: 0 }, grid: { color: 'rgba(26,26,26,0.08)' } },
                x: { grid: { display: false } }
            }
        };

        function clone(o) { return JSON.parse(JSON.stringify(o)); }

        // 1. Monthly inquiries
        var o1 = clone(baseOpts);
        o1.plugins.legend.display = false;
        new Chart(document.getElementById('chMonthly'), {
            type: 'line',
            data: {
                labels: monthly.labels,
                datasets: [{
                    label: 'Inquiries',
                    data: monthly.data,
                    borderColor: GOLD,
                    backgroundColor: 'rgba(156,127,80,0.16)',
                    fill: true,
                    tension: 0.35,
                    pointBackgroundColor: GOLD
                }]
            },
            options: o1
        });

        // 2. Sales / Rentals status (stacked)
        var o2 = clone(baseOpts);
        o2.scales.x.stacked = true;
        o2.scales.y.stacked = true;
        new Chart(document.getElementById('chStatus'), {
            type: 'bar',
            data: {
                labels: statusData.labels,
                datasets: [
                    { label: 'Closed (Sold / Rented)', data: statusData.closed, backgroundColor: GREEN },
                    { label: 'Pending', data: statusData.pending, backgroundColor: GOLD }
                ]
            },
            options: o2
        });

        // 3. Agent performance
        new Chart(document.getElementById('chAgents'), {
            type: 'bar',
            data: {
                labels: agents.names,
                datasets: [
                    { label: 'Listings', data: agents.listings, backgroundColor: DARK },
                    { label: 'Closed', data: agents.closed, backgroundColor: GREEN },
                    { label: 'Pending', data: agents.pending, backgroundColor: GOLD }
                ]
            },
            options: clone(baseOpts)
        });

        // 4. Revenue by agent
        var o4 = clone(baseOpts);
        o4.indexAxis = 'y';
        o4.plugins.legend.display = false;
        o4.scales.y = { grid: { display: false } };
        o4.scales.x = { beginAtZero: true, grid: { color: 'rgba(26,26,26,0.08)' }, ticks: { callback: function (v) { return '$' + new Intl.NumberFormat('en', { notation: 'compact' }).format(v); } } };
        new Chart(document.getElementById('chRevenue'), {
            type: 'bar',
            data: {
                labels: agents.names,
                datasets: [{ label: 'Sold Revenue ($)', data: agents.revenue, backgroundColor: GOLD }]
            },
            options: o4
        });
    </script>

</asp:Content>
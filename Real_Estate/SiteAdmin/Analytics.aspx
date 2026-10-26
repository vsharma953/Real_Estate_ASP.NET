

<%@ Page Title="Analytics" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="Real_Estate.SiteAdmin.Analytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .report-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .report-title {
            margin: 0 0 6px 0;
            font-size: 28px;
            color: #222;
        }

        .report-subtitle {
            margin: 0;
            color: #777;
        }

        .print-date {
            display: none;
        }

        .print-button {
            padding: 9px 22px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            background: #222;
            color: #fff;
        }

            .print-button:hover {
                background: #a98750;
            }

        .metrics-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .metric-card {
            flex: 1;
            min-width: 170px;
            padding: 22px;
            background: #fff;
            border: 1px solid #EAEAEA;
            border-radius: 4px;
        }

        .metric-title {
            margin: 0;
            color: #777;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .metric-value {
            font-size: 28px;
            font-weight: 700;
            color: #111;
            margin: 8px 0 0 0;
        }

        .chart-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .chart-card {
            flex: 1;
            min-width: 340px;
            background: #fff;
            padding: 22px;
            border: 1px solid #EAEAEA;
            border-radius: 4px;
        }

            .chart-card.wide {
                flex: 2;
            }

        .chart-title {
            margin: 0 0 4px 0;
            font-size: 16px;
            color: #111;
        }

        .chart-sub {
            margin: 0 0 16px 0;
            font-size: 12px;
            color: #888;
        }

        .chart-box {
            position: relative;
            height: 300px;
        }

        .message {
            display: block;
            padding: 10px 12px;
            background: #f7f3ec;
            border-left: 3px solid #a98750;
            color: #555;
            margin-bottom: 20px;
        }

        .perf-grid {
            width: 100%;
            border-collapse: collapse;
        }

            .perf-grid th {
                background: #222;
                color: #fff;
                padding: 12px 10px;
                text-align: left;
                font-weight: 600;
                font-size: 13px;
            }

            .perf-grid td {
                padding: 10px;
                border-bottom: 1px solid #e5e5e5;
                font-size: 13px;
                color: #333;
            }

            .perf-grid tr:hover td {
                background: #faf9f6;
            }

        .table-wrap {
            overflow-x: auto;
        }

        /* ---------- PRINT ---------- */
        @page {
            size: A4 landscape;
            margin: 10mm;
        }

        @media print {
            * {
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            html, body {
                height: auto !important;
                overflow: visible !important;
                background: #fff !important;
            }

            /* Sirf report dikhao, sidebar aur master ka baaki hissa chhupao */
            body * { visibility: hidden; }
            #reportArea, #reportArea * { visibility: visible; }

            #reportArea {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }

            .print-button { display: none !important; }
            .print-date { display: block; color: #777; font-size: 12px; margin-top: 4px; }

            .metrics-row { flex-wrap: nowrap; gap: 10px; }
            .metric-card { min-width: 0; padding: 12px; }
            .metric-value { font-size: 22px; }

            .chart-row { flex-wrap: nowrap; gap: 10px; break-inside: avoid; page-break-inside: avoid; }
            .chart-card { min-width: 0; padding: 14px; break-inside: avoid; page-break-inside: avoid; }
            .chart-box { height: 230px; }

            .perf-grid th, .perf-grid td { padding: 6px 8px; font-size: 11px; }
        }
    </style>
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

        <div class="chart-card" style="margin-bottom: 20px;">
            <h3 class="chart-title">Agent Scorecard</h3>
            <p class="chart-sub">Detailed breakdown per agent</p>
            <div class="table-wrap">
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

    </div> <!-- /reportArea -->

    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
    <script>
        var monthly = <%= MonthlyJson %>;
        var statusData = <%= StatusJson %>;
        var agents     = <%= AgentJson %>;

        var GOLD = '#a98750', DARK = '#222222', GREEN = '#4f8a5b';

        Chart.defaults.font.family = 'inherit';
        Chart.defaults.color = '#555';
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
                y: { beginAtZero: true, ticks: { precision: 0 }, grid: { color: '#f0f0f0' } },
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
                    backgroundColor: 'rgba(169,135,80,0.15)',
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
        o4.scales.x = { beginAtZero: true, grid: { color: '#f0f0f0' } };
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
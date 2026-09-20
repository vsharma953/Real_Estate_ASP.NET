<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Real_Estate.SiteAdmin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .metrics-row {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .metric-card {
            flex: 1;
            min-width: 180px;
            padding: 25px;
            background: #fff;
            border: 1px solid #EAEAEA;
            border-radius: 4px;
        }

        .metric-title {
            margin-top: 0;
            color: #777;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .metric-value {
            font-size: 32px;
            font-weight: 700;
            color: #111;
            margin: 8px 0 0 0;
        }

        .activity-row {
            display: flex;
            gap: 20px;
        }

        .activity-card {
            flex: 1;
            background: #fff;
            padding: 25px;
            border: 1px solid #EAEAEA;
            border-radius: 4px;
            overflow-x: auto;
        }

        .activity-title {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 16px;
            color: #111111;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .grid-header th {
            background-color: #FAFAFA;
            color: #555555;
            padding: 12px;
            text-align: left;
            font-size: 12px;
            border-bottom: 2px solid #EAEAEA;
        }

        .grid-row td {
            padding: 12px;
            border-bottom: 1px solid #EAEAEA;
            color: #333;
            font-size: 13px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="metrics-row">
        <div class="metric-card">
            <p class="metric-title">Total Agents</p>
            <p class="metric-value"><asp:Literal ID="litTotalAgents" runat="server" Text="0"></asp:Literal></p>
        </div>
        <div class="metric-card">
            <p class="metric-title">Active Agents</p>
            <p class="metric-value"><asp:Literal ID="litActiveAgents" runat="server" Text="0"></asp:Literal></p>
        </div>
        <div class="metric-card">
            <p class="metric-title">Total Properties</p>
            <p class="metric-value"><asp:Literal ID="litTotalProperties" runat="server" Text="0"></asp:Literal></p>
        </div>
        <div class="metric-card">
            <p class="metric-title">Total Inquiries</p>
            <p class="metric-value"><asp:Literal ID="litTotalInquiries" runat="server" Text="0"></asp:Literal></p>
        </div>
        <div class="metric-card">
            <p class="metric-title">Total Sell Amount</p>
            <p class="metric-value"><asp:Literal ID="litTotalSell" runat="server" Text="$0"></asp:Literal></p>
        </div>
    </div>

    <div class="activity-row">
        <div class="activity-card">
            <h3 class="activity-title">Agents</h3>
            <asp:GridView ID="gvRecentAgents" runat="server" CssClass="table" AutoGenerateColumns="False" GridLines="None" EmptyDataText="No agents yet - add one from Manage Agents.">
                <HeaderStyle CssClass="grid-header" />
                <RowStyle CssClass="grid-row" />
                <Columns>
                    <asp:TemplateField HeaderText="Name">
                        <ItemTemplate>
                            <asp:Label ID="lblName" runat="server" Text='<%# Eval("FullName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Email">
                        <ItemTemplate>
                            <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Listings">
                        <ItemTemplate>
                            <asp:Label ID="lblListings" runat="server" Text='<%# Eval("Listings") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

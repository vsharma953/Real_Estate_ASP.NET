<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Real_Estate.SiteAdmin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
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
            <p class="metric-title">Properties For Sale</p>
            <p class="metric-value"><asp:Literal ID="litForSale" runat="server" Text="0"></asp:Literal></p>
        </div>
        <div class="metric-card">
            <p class="metric-title">Properties For Rent</p>
            <p class="metric-value"><asp:Literal ID="litForRent" runat="server" Text="0"></asp:Literal></p>
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
            <div class="table-scroll">
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
    </div>
</asp:Content>

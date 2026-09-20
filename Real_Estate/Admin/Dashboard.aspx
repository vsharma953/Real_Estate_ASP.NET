<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Real_Estate.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .metrics-row {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .metric-card {
            flex: 1;
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

        .quick-actions {
            margin-bottom: 40px;
        }

        .btn-action {
            padding: 12px 24px;
            background: #111111;
            color: #FFFFFF;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 15px;
            font-weight: 500;
            display: inline-block;
            font-size: 14px;
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
    <div class="activity-row">
        <div class="activity-card">
            <h3 class="activity-title">Latest Inquiries</h3>
            <asp:GridView ID="gvRecentInquiries" runat="server" CssClass="table" AutoGenerateColumns="False" GridLines="None" EmptyDataText="No recent inquiries yet.">
                <HeaderStyle CssClass="grid-header" />
                <RowStyle CssClass="grid-row" />
                <Columns>
                    <asp:TemplateField HeaderText="Name">
                        <ItemTemplate>
                            <asp:Label ID="lblDashName" runat="server" Text='<%# Eval("FullName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Phone">
                        <ItemTemplate>
                            <asp:Label ID="lblDashPhone" runat="server" Text='<%# Eval("Phone") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Property">
                        <ItemTemplate>
                            <asp:Label ID="lblDashProperty" runat="server" Text='<%# Eval("Property") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Message">
                        <ItemTemplate>
                            <asp:Label ID="lblDashMessage" runat="server" Text='<%# Eval("Message") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date">
                        <ItemTemplate>
                            <asp:Label ID="lblDashDate" runat="server" Text='<%# Eval("InquiryDate", "{0:dd/MM/yyyy}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
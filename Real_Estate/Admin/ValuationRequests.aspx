<%@ Page Title="Valuation Requests" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ValuationRequests.aspx.cs" Inherits="Real_Estate.Admin.ValuationRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .panel-container {
            background: #fff;
            padding: 30px;
            border: 1px solid #EAEAEA;
            border-radius: 4px;
        }

        .panel-title {
            color: #111111;
            margin-top: 0;
            margin-bottom: 5px;
        }

        .panel-desc {
            color: #777777;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .btn-grid {
            background: #FAFAFA;
            color: #111111;
            padding: 6px 12px;
            border: 1px solid #EAEAEA;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }

            .btn-grid:hover {
                background: #111111;
                color: #FFFFFF;
            }

        .table-responsive {
            overflow-x: auto;
        }

        /* GridView Minimal Styling */
        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .grid-header th {
            background-color: #FAFAFA;
            color: #555555;
            padding: 15px;
            text-align: left;
            font-size: 12px;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #EAEAEA;
        }

        .grid-row td {
            padding: 15px;
            border-bottom: 1px solid #EAEAEA;
            color: #333;
            font-size: 14px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="panel-container">

        <h2 class="panel-title">Pending Valuation Requests</h2>
        <p class="panel-desc">Review incoming requests and follow up with homeowners.</p>

        <div class="table-responsive">
            <asp:GridView ID="gvValuations" runat="server" CssClass="table" AutoGenerateColumns="False" OnRowCommand="gvValuations_RowCommand" GridLines="None" EmptyDataText="No valuation requests are connected yet.">
                <HeaderStyle CssClass="grid-header" />
                <RowStyle CssClass="grid-row" />
                <Columns>
                    <asp:TemplateField HeaderText="ID">
                        <ItemTemplate>
                            <asp:Label ID="lblId" runat="server" Text='<%# Eval("RequestID") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Client Name">
                        <ItemTemplate>
                            <asp:Label ID="lblName" runat="server" Text='<%# Eval("FullName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Email Address">
                        <ItemTemplate>
                            <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Phone">
                        <ItemTemplate>
                            <asp:Label ID="lblPhone" runat="server" Text='<%# Eval("Phone") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Property Address">
                        <ItemTemplate>
                            <asp:Label ID="lblAddress" runat="server" Text='<%# Eval("PropertyAddress") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Edit">
                        <ItemTemplate>
                            <asp:Button ID="btnEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Eval("RequestID") %>' Text="Edit" CssClass="btn-grid" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Delete">
                        <ItemTemplate>
                            <asp:Button ID="btnDelete" runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("RequestID") %>' Text="Delete" CssClass="btn-grid" OnClientClick="return confirm('Are you sure you want to delete this request?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

    </div>
</asp:Content>

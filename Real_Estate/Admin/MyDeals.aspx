<%@ Page Title="My Deals" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="MyDeals.aspx.cs" Inherits="Real_Estate.Admin.MyDeals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>

    <div class="metrics-row">
        <div class="metric-card">
            <h4 class="metric-title">Deals closed</h4>
            <div class="metric-value"><asp:Literal ID="litTotal" runat="server"></asp:Literal></div>
        </div>
        <div class="metric-card">
            <h4 class="metric-title">Waiting for approval</h4>
            <div class="metric-value"><asp:Literal ID="litPending" runat="server"></asp:Literal></div>
        </div>
        <div class="metric-card">
            <h4 class="metric-title">Approved sales value</h4>
            <div class="metric-value"><asp:Literal ID="litSalesValue" runat="server"></asp:Literal></div>
        </div>
        <div class="metric-card">
            <h4 class="metric-title">Commission earned</h4>
            <div class="metric-value"><asp:Literal ID="litEarned" runat="server"></asp:Literal></div>
        </div>
        <div class="metric-card">
            <h4 class="metric-title">Commission paid</h4>
            <div class="metric-value"><asp:Literal ID="litPaid" runat="server"></asp:Literal></div>
        </div>
    </div>

    <div class="activity-card">

        <div class="toolbar">
            <label for="<%= ddlStatusFilter.ClientID %>">Show</label>
            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                <asp:ListItem Text="All deals" Value=""></asp:ListItem>
                <asp:ListItem Text="Pending"></asp:ListItem>
                <asp:ListItem Text="Approved"></asp:ListItem>
                <asp:ListItem Text="Rejected"></asp:ListItem>
                <asp:ListItem Text="Paid"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="table-scroll">
<asp:GridView ID="gvDeals" runat="server" CssClass="table" AutoGenerateColumns="False" GridLines="None"
            EmptyDataText="No deals yet. Close a deal from an inquiry marked Deal Done, or from the Properties page."
            OnRowDataBound="gvDeals_RowDataBound" OnRowCommand="gvDeals_RowCommand">
            <HeaderStyle CssClass="grid-header" />
            <RowStyle CssClass="grid-row" />
            <Columns>

                <asp:TemplateField HeaderText="Deal">
                    <ItemTemplate>
                        <strong>#<%#: Eval("DealID") %></strong><br />
                        <span class="muted"><%#: Eval("CreatedOn", "{0:dd/MM/yyyy}") %></span><br />
                        <span class="muted"><%# TypeText(Eval("DealType")) %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Property">
                    <ItemTemplate>
                        <%#: Eval("PropertyTitle") %><br />
                        <span class="muted"><%#: Eval("PropertyLocation") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Client">
                    <ItemTemplate>
                        <strong><%#: Eval("ClientName") %></strong><br />
                        <%#: Eval("ClientPhone") %><br />
                        <span class="muted"><%#: Eval("ClientEmail") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Terms">
                    <ItemTemplate>
                        <%# TermsHtml(Container.DataItem) %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Money">
                    <ItemTemplate>
                        <%# MoneyHtml(Container.DataItem) %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Commission">
                    <ItemTemplate>
                        <%# CommissionHtml(Container.DataItem) %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="status-pill"><%#: Eval("Status") %></span>
                        <%# ReasonHtml(Eval("RejectReason")) %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Add Payment">
                    <ItemTemplate>
                        <asp:Panel ID="pnlAddPay" runat="server">
                            <asp:TextBox ID="txtPayAmt" runat="server" CssClass="form-control small-input" placeholder="Amount"></asp:TextBox><br />
                            <asp:DropDownList ID="ddlPayMode" runat="server" CssClass="form-control small-input">
                                <asp:ListItem Text="Mode" Value=""></asp:ListItem>
                                <asp:ListItem Text="Cash"></asp:ListItem>
                                <asp:ListItem Text="Bank Transfer"></asp:ListItem>
                                <asp:ListItem Text="Cheque"></asp:ListItem>
                                <asp:ListItem Text="UPI"></asp:ListItem>
                                <asp:ListItem Text="Card"></asp:ListItem>
                            </asp:DropDownList><br />
                            <asp:TextBox ID="txtPayRef" runat="server" CssClass="form-control small-input" MaxLength="100" placeholder="Reference"></asp:TextBox><br />
                            <asp:Button ID="btnAddPay" runat="server" Text="Add" CssClass="grid-button" CommandName="AddPay" CommandArgument='<%# Eval("DealID") %>' />
                        </asp:Panel>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
</div>

    </div>
</asp:Content>

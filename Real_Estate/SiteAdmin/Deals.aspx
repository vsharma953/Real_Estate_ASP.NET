<%@ Page Title="Deals" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Deals.aspx.cs" Inherits="Real_Estate.SiteAdmin.Deals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="manage-box">

        <h2 class="manage-title">Deals</h2>

        <p class="manage-subtitle">
            Every sale and rental closed by the agents: who did it, for which client and property, and the money involved.
            Open a deal to approve it, reject it, or mark the agent's commission as paid.
        </p>

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <div class="metrics-row">
            <div class="metric-card">
                <h4 class="metric-title">Deals</h4>
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
                <h4 class="metric-title">Commission payable</h4>
                <div class="metric-value"><asp:Literal ID="litDue" runat="server"></asp:Literal></div>
            </div>
            <div class="metric-card">
                <h4 class="metric-title">Commission paid</h4>
                <div class="metric-value"><asp:Literal ID="litPaid" runat="server"></asp:Literal></div>
            </div>
            <div class="metric-card">
                <h4 class="metric-title">Rentals recorded</h4>
                <div class="metric-value"><asp:Literal ID="litRentals" runat="server"></asp:Literal></div>
            </div>
        </div>

        <div class="filter-row">

            <div class="filter-item">
                <label for="<%= ddlAgentFilter.ClientID %>">Agent</label>
                <asp:DropDownList ID="ddlAgentFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="filter_Changed"></asp:DropDownList>
            </div>

            <div class="filter-item">
                <label for="<%= ddlStatusFilter.ClientID %>">Status</label>
                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="filter_Changed">
                    <asp:ListItem Text="All statuses" Value=""></asp:ListItem>
                    <asp:ListItem Text="Pending"></asp:ListItem>
                    <asp:ListItem Text="Approved"></asp:ListItem>
                    <asp:ListItem Text="Rejected"></asp:ListItem>
                    <asp:ListItem Text="Paid"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="filter-item">
                <label for="<%= ddlTypeFilter.ClientID %>">Type</label>
                <asp:DropDownList ID="ddlTypeFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="filter_Changed"></asp:DropDownList>
            </div>

            <div class="filter-item">
                <label for="<%= txtFrom.ClientID %>">From</label>
                <asp:TextBox ID="txtFrom" runat="server" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="filter_Changed"></asp:TextBox>
            </div>

            <div class="filter-item">
                <label for="<%= txtTo.ClientID %>">To</label>
                <asp:TextBox ID="txtTo" runat="server" TextMode="Date" CssClass="form-control" AutoPostBack="true" OnTextChanged="filter_Changed"></asp:TextBox>
            </div>

            <div class="filter-item">
                <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="grid-button" CausesValidation="false" OnClick="btnReset_Click" />
            </div>

        </div>

        <div class="table-scroll">
<asp:GridView ID="gvDeals" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="property-grid"
            EmptyDataText="No deals match these filters.">
            <Columns>

                <asp:TemplateField HeaderText="Deal">
                    <ItemTemplate>
                        <strong>#<%#: Eval("DealID") %></strong><br />
                        <span class="muted"><%#: Eval("CreatedOn", "{0:dd/MM/yyyy}") %></span><br />
                        <span class="muted"><%# TypeText(Eval("DealType")) %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Agent">
                    <ItemTemplate>
                        <%#: Eval("AgentName") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Client">
                    <ItemTemplate>
                        <strong><%#: Eval("ClientName") %></strong><br />
                        <%#: Eval("ClientPhone") %><br />
                        <span class="muted"><%#: Eval("ClientEmail") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Property">
                    <ItemTemplate>
                        <%#: Eval("PropertyTitle") %><br />
                        <span class="muted"><%#: Eval("PropertyType") %> | <%#: Eval("PropertyLocation") %></span>
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
                        <span class="pill"><%#: Eval("Status") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <a class="grid-button" href='DealDetail.aspx?id=<%#: Eval("DealID") %>'>Open</a>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
</div>

    </div>
</asp:Content>

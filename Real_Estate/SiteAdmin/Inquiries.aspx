<%@ Page Title="Inquiries" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Inquiries.aspx.cs" Inherits="Real_Estate.SiteAdmin.Inquiries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="manage-box">

        <h2 class="manage-title">Inquiries</h2>

        <p class="manage-subtitle">
            Every inquiry sent from the website, across all agents. An inquiry goes to the agent of its property;
            you can hand any inquiry to a different agent, and inquiries with no agent are shown as Unassigned.
        </p>

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <div class="filter-row">

            <div class="filter-item">
                <label for="<%= ddlAgentFilter.ClientID %>">Agent</label>
                <asp:DropDownList ID="ddlAgentFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="filter_Changed"></asp:DropDownList>
            </div>

            <div class="filter-item">
                <label for="<%= ddlStatusFilter.ClientID %>">Status</label>
                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="filter_Changed">
                    <asp:ListItem Text="All statuses" Value=""></asp:ListItem>
                    <asp:ListItem Text="New"></asp:ListItem>
                    <asp:ListItem Text="Contacted"></asp:ListItem>
                    <asp:ListItem Text="Negotiating"></asp:ListItem>
                    <asp:ListItem Text="Deal Done"></asp:ListItem>
                    <asp:ListItem Text="Lost"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="filter-item">
                <label for="<%= ddlListingFilter.ClientID %>">Listing</label>
                <asp:DropDownList ID="ddlListingFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="filter_Changed"></asp:DropDownList>
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

        <asp:Label ID="lblSummary" runat="server" CssClass="summary"></asp:Label>

        <div class="table-scroll">
<asp:GridView ID="gvInquiries" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="property-grid"
            EmptyDataText="No inquiries match these filters."
            OnRowDataBound="gvInquiries_RowDataBound" OnRowCommand="gvInquiries_RowCommand">
            <Columns>

                <asp:TemplateField HeaderText="Date">
                    <ItemTemplate>
                        <%#: Eval("InquiryDate", "{0:dd/MM/yyyy}") %><br />
                        <span class="muted"><%#: Eval("InquiryDate", "{0:hh:mm tt}") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Client">
                    <ItemTemplate>
                        <strong><%#: Eval("FullName") %></strong><br />
                        <a href='<%#: TelHref(Eval("Phone")) %>'><%#: Eval("Phone") %></a><br />
                        <a href='mailto:<%#: Eval("Email") %>'><%#: Eval("Email") %></a>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Property">
                    <ItemTemplate>
                        <%#: Eval("Property") %><br />
                        <span class="muted"><%# PropertyMeta(Eval("ListingType"), Eval("Location")) %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Message">
                    <ItemTemplate>
                        <div class="msg-text"><%#: Eval("Message") %></div>
                        <%# NoteHtml(Eval("AgentNote")) %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <span class="pill"><%#: Eval("StatusName") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Agent">
                    <ItemTemplate>
                        <span class='<%# Eval("OwnerID") == DBNull.Value ? "pill pill-warn" : "pill" %>'><%#: Eval("AgentName") %></span>
                        <%# Eval("AssignedAgentID") == DBNull.Value ? "" : "<br /><span class=\"muted\">Assigned manually</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Assign To">
                    <ItemTemplate>
                        <asp:DropDownList ID="ddlAssign" runat="server" CssClass="form-control"></asp:DropDownList><br />
                        <asp:Button ID="btnAssign" runat="server" Text="Assign" CssClass="grid-button" CommandName="AssignRow" CommandArgument='<%# Eval("InquiryID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
</div>

    </div>
</asp:Content>

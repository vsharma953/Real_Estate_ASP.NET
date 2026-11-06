<%@ Page Title="Inquiries" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Inquiries.aspx.cs" Inherits="Real_Estate.Admin.Inquiries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="activity-card">

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="notice"></asp:Label>

        <div class="toolbar">
            <label for="<%= ddlStatusFilter.ClientID %>">Show</label>
            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                <asp:ListItem Text="All inquiries" Value=""></asp:ListItem>
                <asp:ListItem Text="New"></asp:ListItem>
                <asp:ListItem Text="Contacted"></asp:ListItem>
                <asp:ListItem Text="Negotiating"></asp:ListItem>
                <asp:ListItem Text="Deal Done"></asp:ListItem>
                <asp:ListItem Text="Lost"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="table-scroll">
<asp:GridView ID="gvInquiries" runat="server" CssClass="table" AutoGenerateColumns="False" GridLines="None"
            DataKeyNames="InquiryID" EmptyDataText="No inquiries found for your properties."
            OnRowDataBound="gvInquiries_RowDataBound" OnRowCommand="gvInquiries_RowCommand">
            <HeaderStyle CssClass="grid-header" />
            <RowStyle CssClass="grid-row" />
            <Columns>
                <asp:TemplateField HeaderText="Date">
                    <ItemTemplate>
                        <%#: Eval("InquiryDate", "{0:dd/MM/yyyy}") %><br />
                        <%#: Eval("InquiryDate", "{0:hh:mm tt}") %>
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
                        <%#: Eval("Property") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Message">
                    <ItemTemplate>
                        <div class="msg-text"><%#: Eval("Message") %></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <asp:DropDownList ID="ddlRowStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Text="New"></asp:ListItem>
                            <asp:ListItem Text="Contacted"></asp:ListItem>
                            <asp:ListItem Text="Negotiating"></asp:ListItem>
                            <asp:ListItem Text="Deal Done"></asp:ListItem>
                            <asp:ListItem Text="Lost"></asp:ListItem>
                        </asp:DropDownList>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Deal">
                    <ItemTemplate>
                        <asp:HyperLink ID="hlCloseDeal" runat="server" Visible="false" CssClass="grid-button deal-link">Close Deal</asp:HyperLink>
                        <asp:Label ID="lblDealInfo" runat="server" Visible="false" CssClass="deal-info"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="My Note">
                    <ItemTemplate>
                        <asp:TextBox ID="txtRowNote" runat="server" TextMode="MultiLine" Rows="3" MaxLength="500" CssClass="form-control note-box"
                            Text='<%# Eval("AgentNote") %>' placeholder="Call summary, follow-up date..."></asp:TextBox><br />
                        <asp:Button ID="btnSaveRow" runat="server" Text="Save" CssClass="grid-button" CommandName="SaveRow" CommandArgument='<%# Eval("InquiryID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
</div>

    </div>
</asp:Content>

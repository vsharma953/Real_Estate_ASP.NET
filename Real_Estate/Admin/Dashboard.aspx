<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Real_Estate.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="activity-row">
        <div class="activity-card">
            <h3 class="activity-title">Latest Inquiries
                <a href="Inquiries.aspx" class="view-all">View all inquiries</a>
            </h3>
            <div class="table-scroll">
<asp:GridView ID="gvRecentInquiries" runat="server" CssClass="table" AutoGenerateColumns="False" GridLines="None" EmptyDataText="No inquiries for your properties yet.">
                <HeaderStyle CssClass="grid-header" />
                <RowStyle CssClass="grid-row" />
                <Columns>
                    <asp:TemplateField HeaderText="Client">
                        <ItemTemplate>
                            <strong><%#: Eval("FullName") %></strong><br />
                            <a href='mailto:<%#: Eval("Email") %>'><%#: Eval("Email") %></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Mobile">
                        <ItemTemplate>
                            <a href='<%#: TelHref(Eval("Phone")) %>'><%#: Eval("Phone") %></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Property">
                        <ItemTemplate>
                            <%#: Eval("Property") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Message">
                        <ItemTemplate>
                            <%#: Eval("Message") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class="status-pill"><%#: Eval("Status") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date">
                        <ItemTemplate>
                            <%#: Eval("InquiryDate", "{0:dd/MM/yyyy}") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
</div>
        </div>
    </div>
</asp:Content>
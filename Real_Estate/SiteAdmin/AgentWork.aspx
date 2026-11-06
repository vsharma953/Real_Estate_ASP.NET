<%@ Page Title="Agent Work" Language="C#" MasterPageFile="~/SiteAdmin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AgentWork.aspx.cs" Inherits="Real_Estate.SiteAdmin.AgentWork" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="manage-box">

        <h2 class="manage-title">Agent Work</h2>

        <p class="manage-subtitle">
            Every property listed across every agent, split into sale and rent. Move a listing to another agent when needed.
        </p>

        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <div class="filter-row">
            <label>Filter by Agent:</label>
            <asp:DropDownList ID="ddlAgentFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlAgentFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Agents" Value="0"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="tab-bar">
            <asp:Repeater ID="rptTabs" runat="server" OnItemCommand="rptTabs_ItemCommand">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkTab" runat="server" CausesValidation="false"
                        CommandName="Tab" CommandArgument='<%# Eval("Value") %>'
                        CssClass='<%# IsActiveTab(Eval("Value")) ? "tab-link tab-active" : "tab-link" %>'>
                        <%#: Eval("Text") %><span class="tab-count"><%#: Eval("Total") %></span>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="table-scroll">
<asp:GridView ID="gvAgentWork" runat="server" AutoGenerateColumns="False" GridLines="None" CssClass="property-grid" OnRowCommand="gvAgentWork_RowCommand" OnRowDataBound="gvAgentWork_RowDataBound" EmptyDataText="No properties have been listed yet.">
            <Columns>

                <asp:TemplateField HeaderText="ID">
                    <ItemTemplate>
                        <asp:Label ID="lblID" runat="server" Text='<%# Eval("PropertyID") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Title">
                    <ItemTemplate>
                        <asp:Label ID="lblTitle" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Agent">
                    <ItemTemplate>
                        <asp:Label ID="lblAgentName" runat="server" Text='<%# Eval("AgentName") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Type">
                    <ItemTemplate>
                        <asp:Label ID="lblType" runat="server" Text='<%# Eval("PropertyType") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Price">
                    <ItemTemplate>
                        <asp:Label ID="lblPrice" runat="server" Text='<%# Eval("Price") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Location">
                    <ItemTemplate>
                        <asp:Label ID="lblLocation" runat="server" Text='<%# Eval("Location") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Inquiries">
                    <ItemTemplate>
                        <asp:Label ID="lblInquiries" runat="server" Text='<%# Eval("InquiryCount") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Move To">
                    <ItemTemplate>
                        <asp:DropDownList ID="ddlMoveTo" runat="server" CssClass="form-control"></asp:DropDownList>
                        <asp:Button ID="btnMove" runat="server" Text="Move" CssClass="grid-button" CommandName="MoveRow" CommandArgument='<%# Eval("PropertyID") %>' OnClientClick="return confirm('Move this listing to the selected agent?');" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Remove">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="grid-button delete-button" CommandName="DeleteRow" CommandArgument='<%# Eval("PropertyID") %>' OnClientClick="return confirm('Remove this listing?');" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
</div>
    </div>
</asp:Content>
